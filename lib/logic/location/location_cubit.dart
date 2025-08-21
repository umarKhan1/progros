import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:progros/logic/location/location_state.dart';
import 'package:progros/models/place_pridiction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit({this.placesApiKey})
      : super(LocationState(cameraTarget: const LatLng(20.5937, 78.9629)));

  final String? placesApiKey; // plug your key to use real APIs
  GoogleMapController? _map;
  SharedPreferences? _prefs;
  Timer? _debounce;

  // ---------- Permission Gate ----------
  Future<void> startPermissionGate() async {
    _prefs = await SharedPreferences.getInstance();
    await _checkAndRequestPermission();
  }

  Future<void> _checkAndRequestPermission() async {
    emit(state.copyWith(checkingPermission: true));

    // Service enabled?
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      emit(state.copyWith(
        permission: PermissionStatusX.serviceDisabled,
        checkingPermission: false,
      ));
      return;
    }

    var p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) {
      p = await Geolocator.requestPermission();
    }

    if (p == LocationPermission.whileInUse || p == LocationPermission.always) {
      emit(state.copyWith(
        permission: PermissionStatusX.granted,
        checkingPermission: false,
      ));
      // Preload for dashboard
      await fetchCurrentLocationAndAddress();
    } else if (p == LocationPermission.deniedForever) {
      emit(state.copyWith(
        permission: PermissionStatusX.deniedForever,
        checkingPermission: false,
      ));
    } else {
      emit(state.copyWith(
        permission: PermissionStatusX.denied,
        checkingPermission: false,
      ));
    }
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
    await _checkAndRequestPermission();
  }

  // ---------- Map lifecycle ----------
  Future<void> attachMap(GoogleMapController c) async {
    _map = c;

    // If we already have a location, jump there immediately to avoid "India" flash
    if (state.myLocation != null) {
      await _map!.moveCamera(
        CameraUpdate.newLatLngZoom(state.myLocation!, 16),
      );
    } else {
      // First time opening map: try to center on me right away
      // ignore: unawaited_futures
      centerOnMyLocation();
    }
  }

  // ---------- Location helpers ----------
  Future<Position> _safeGetPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationServiceDisabledException();
    }

    var p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) {
      p = await Geolocator.requestPermission();
    }
    if (p == LocationPermission.denied || p == LocationPermission.deniedForever) {
      throw PermissionDeniedException('Location permission denied',);
    }

    try {
      // Try fast, high accuracy first
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 8),
      );
    } catch (_) {
      // Fallback to last known
      final last = await Geolocator.getLastKnownPosition();
      if (last != null) return last;
      rethrow;
    }
  }

  Future<void> fetchCurrentLocationAndAddress() => centerOnMyLocation();

  Future<void> centerOnMyLocation() async {
    emit(state.copyWith(locatingMe: true));
    try {
      final pos = await _safeGetPosition();
      final me = LatLng(pos.latitude, pos.longitude);
      final addr = await _reverseGeocode(me.latitude, me.longitude);

      emit(state.copyWith(
        myLocation: me,
        cameraTarget: me,
        currentAddress: addr,
        locatingMe: false,
      ));

      if (_map != null) {
        await _map!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: me, zoom: 16, tilt: 0, bearing: 0),
          ),
        );
      }
    } catch (_) {
      emit(state.copyWith(locatingMe: false));
    }
  }

  // ---------- Camera / reverse geocode ----------
  void onCameraMove(CameraPosition p) {
    emit(state.copyWith(cameraTarget: p.target));
  }

  Future<void> onCameraIdle() async {
    final t = state.cameraTarget;
    emit(state.copyWith(loadingAddress: true));
    final addr = await _reverseGeocode(t.latitude, t.longitude);
    emit(state.copyWith(currentAddress: addr, loadingAddress: false));
  }

  // ---------- Search / predictions ----------
  Future<void> searchChanged(String q) async {
    emit(state.copyWith(searchQuery: q));
    _debounce?.cancel();

    if (q.trim().isEmpty) {
      emit(state.copyWith(predictions: const []));
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      final list = await _autocomplete(q);
      emit(state.copyWith(predictions: list));
    });
  }

  Future<void> pickPrediction(PlacePrediction p) async {
    emit(state.copyWith(predictions: [], searchQuery: p.description));
    final target = await _placeDetailLatLng(p.placeId);
    if (_map != null) {
      await _map!.animateCamera(CameraUpdate.newLatLngZoom(target, 16));
    }
    // onCameraIdle will update the pretty address
  }

  // ---------- Save ----------
  Future<void> confirmAddress() async {
    emit(state.copyWith(saving: true));
    final t = state.cameraTarget;
    await _prefs?.setString('saved_address', state.currentAddress);
    await _prefs?.setDouble('saved_lat', t.latitude);
    await _prefs?.setDouble('saved_lng', t.longitude);
    emit(state.copyWith(saving: false));
  }

  String? getSavedAddress() => _prefs?.getString('saved_address');

  // ---------- Inline API helpers ----------
  Future<List<PlacePrediction>> _autocomplete(String query) async {
    if (placesApiKey == null) {
      // Mock so UI remains usable without an API key
      return List.generate(
        5,
        (i) => PlacePrediction(
          placeId: 'mock_$i',
          description: '$query suggestion #$i, City',
        ),
      );
    }

    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${Uri.encodeComponent(query)}&key=$placesApiKey';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) return const [];
    final json = jsonDecode(res.body);
    final preds = (json['predictions'] ?? []) as List;
    return preds
        .map((e) => PlacePrediction(
              placeId: e['place_id'].toString(),
              description: e['description'].toString(),
            ))
        .cast<PlacePrediction>()
        .toList();
  }

  Future<LatLng> _placeDetailLatLng(String placeId) async {
    if (placesApiKey == null) {
      final base = state.myLocation ?? state.cameraTarget;
      return LatLng(base.latitude + 0.001, base.longitude + 0.001);
    }

    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$placesApiKey';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) return state.cameraTarget;

    final json = jsonDecode(res.body);
    final loc = json['result']?['geometry']?['location'];
    if (loc == null) return state.cameraTarget;

    return LatLng(
      (loc['lat'] as num).toDouble(),
      (loc['lng'] as num).toDouble(),
    );
  }

  Future<String> _reverseGeocode(double lat, double lng) async {
    if (placesApiKey == null) {
      return 'Lat: ${lat.toStringAsFixed(5)}, Lng: ${lng.toStringAsFixed(5)}';
    }

    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$placesApiKey';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) return '($lat, $lng)';

    final json = jsonDecode(res.body);
    final results = (json['results'] as List?) ?? [];
    return results.isNotEmpty
        ? results.first['formatted_address'].toString()
        : '($lat, $lng)';
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}

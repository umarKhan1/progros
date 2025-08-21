import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progros/models/place_pridiction_model.dart';

enum PermissionStatusX {
  unknown,
  granted,
  denied,
  deniedForever,
  serviceDisabled,
}

class LocationState {
  LocationState({
    required this.cameraTarget, this.permission = PermissionStatusX.unknown,
    this.checkingPermission = false,
    this.myLocation,
    this.locatingMe = false,
    this.loadingAddress = false,
    this.saving = false,
    this.currentAddress = '',
    this.predictions = const [],
    this.searchQuery = '',
  });
  // gate
  final PermissionStatusX permission;
  final bool checkingPermission;

  // map / search
  final LatLng cameraTarget;
  final LatLng? myLocation;
  final bool locatingMe;
  final bool loadingAddress;
  final bool saving;
  final String currentAddress;
  final List<PlacePrediction> predictions;
  final String searchQuery;

  LocationState copyWith({
    PermissionStatusX? permission,
    bool? checkingPermission,
    LatLng? cameraTarget,
    LatLng? myLocation,
    bool? locatingMe,
    bool? loadingAddress,
    bool? saving,
    String? currentAddress,
    List<PlacePrediction>? predictions,
    String? searchQuery,
  }) {
    return LocationState(
      permission: permission ?? this.permission,
      checkingPermission: checkingPermission ?? this.checkingPermission,
      cameraTarget: cameraTarget ?? this.cameraTarget,
      myLocation: myLocation ?? this.myLocation,
      locatingMe: locatingMe ?? this.locatingMe,
      loadingAddress: loadingAddress ?? this.loadingAddress,
      saving: saving ?? this.saving,
      currentAddress: currentAddress ?? this.currentAddress,
      predictions: predictions ?? this.predictions,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

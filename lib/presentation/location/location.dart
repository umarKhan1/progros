import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:progros/core/constant/app_stringconst.dart';
import 'package:progros/logic/location/location_cubit.dart';
import 'package:progros/logic/location/location_state.dart';
import 'package:progros/presentation/location/widget/bottom_address_sheet.dart';
import 'package:progros/presentation/location/widget/center_location_button.dart';
import 'package:progros/presentation/location/widget/top_header.dart';

class ConfirmLocationPage extends StatefulWidget {
  const ConfirmLocationPage({super.key});

  @override
  State<ConfirmLocationPage> createState() => _ConfirmLocationPageState();
}

class _ConfirmLocationPageState extends State<ConfirmLocationPage> {
  late final TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) =>
              BlocConsumer<LocationCubit, LocationState>(
                listenWhen: (p, n) =>
                    p.myLocation != n.myLocation ||
                    p.searchQuery != n.searchQuery,
                listener: (context, state) {
                  // keep search text synced from cubit
                  _searchCtrl.value = TextEditingValue(
                    text: state.searchQuery,
                    selection: TextSelection.collapsed(
                      offset: state.searchQuery.length,
                    ),
                  );
                },
                builder: (context, state) {
                  final cubit = context.read<LocationCubit>();
                  final height = 1.sh;

                  // Responsive bottom sheet height
                  final bottomSheetTarget = (height * 0.28)
                      .clamp(220.h, 320.h)
                      ;
                  final bottomInset = isKeyboardVisible
                      ? 0.0
                      : bottomSheetTarget;

                  return Stack(
                    children: [
                      const TopLocationAppBar(),

                      Positioned(
                        top: 60.h,
                        left: 0,
                        right: 0,
                        bottom: bottomInset,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: state.myLocation ?? state.cameraTarget,
                            zoom: 15,
                          ),
                          onMapCreated:
                              cubit.attachMap, // cubit will auto-center
                          onCameraMove: cubit.onCameraMove,
                          onCameraIdle: cubit.onCameraIdle,
                          myLocationEnabled:
                              state.permission == PermissionStatusX.granted,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          compassEnabled: false,
                          mapToolbarEnabled: false,
                        ),
                      ),

                      // Search Field
                      Positioned(
                        top: 76.h,
                        left: 16.w,
                        right: 16.w,
                        child: Material(
                          elevation: 3,
                          borderRadius: BorderRadius.circular(12.r),
                          child: Container(
                            height: 50.h,
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(9.r),
                            ),
                            child: TextField(
                              controller: _searchCtrl,
                              onChanged: cubit.searchChanged,
                              style: TextStyle(fontSize: 14.sp),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: ApplicationStrings.searchLocation,
                                hintStyle: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.black45,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 26.sp,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Predictions list
                      if (state.predictions.isNotEmpty)
                        Positioned(
                          top: 124.h, // keep clear of the search box
                          left: 16.w,
                          right: 16.w,
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(12.r),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 260.h),
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: state.predictions.length,
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 1),
                                itemBuilder: (_, i) {
                                  final p = state.predictions[i];
                                  return ListTile(
                                    dense: true,
                                    leading: Icon(
                                      Icons.place_outlined,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    title: Text(
                                      p.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    onTap: () => cubit.pickPrediction(p),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),

                      // Center pin + loader
                      Positioned.fill(
                        top: 96.h,
                        bottom: bottomInset,
                        child: IgnorePointer(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.place,
                                color: const Color(0xFF2ECC71),
                                size: 36.sp,
                              ),
                              if (state.loadingAddress)
                                Padding(
                                  padding: EdgeInsets.only(top: 6.h),
                                  child: SizedBox(
                                    width: 18.w,
                                    height: 18.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      // Center-on-me FAB (sits above bottom sheet / keyboard)
                      if (isKeyboardVisible)
                        const SizedBox.shrink(key: ValueKey('hidden'))
                      else
                        const CenterLocationButton(),
                      // Bottom sheet (hidden when keyboard is visible)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeIn,
                          child: isKeyboardVisible
                              ? const SizedBox.shrink(key: ValueKey('hidden'))
                              : BottomAddressSheet(
                                  key: const ValueKey('sheet'),
                                  height: bottomSheetTarget,
                                  saving: state.saving,
                                  address: state.currentAddress.isEmpty
                                      ? ApplicationStrings.movetheMap
                                      : state.currentAddress,
                                  onConfirm: () async {
                                    await context
                                        .read<LocationCubit>()
                                        .confirmAddress();
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            ApplicationStrings.addressSaved,
                                          ),
                                        ),
                                      );
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                        ),
                      ),
                    ],
                  );
                },
              ),
        ),
      ),
    );
  }
}

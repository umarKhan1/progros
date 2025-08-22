import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progros/core/extension/app_routes_ext.dart';
import 'package:progros/logic/location/location_cubit.dart';
import 'package:progros/logic/location/location_state.dart';
import 'package:progros/presentation/dashboard/widget/header.dart';
import 'package:progros/presentation/dashboard/widget/search_widget.dart';
import 'package:progros/presentation/location/location.dart';
import 'package:progros/presentation/search/search_view.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LocationCubit>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BlocBuilder<LocationCubit, LocationState>(
              builder: (context, state) {
                final saved = cubit.getSavedAddress();
                final liveAddress = state.currentAddress.isNotEmpty
                    ? state.currentAddress
                    : null;

                return AddressHeader(
                  title: 'Home',
                  address:
                      liveAddress ??
                      saved ??
                      '31, Main Street, Lisboa, Protugal',
                  onTap: () {
                    context.push(const ConfirmLocationPage());
                  },
                  onBagTap: () {
                    // Handle bag tap
                  },
                );
              },
            ),
             SearchEntryRow(
              onOpenSearch: () {
                context.push(const SearchScreen());
              },
              onFilterTap: (){}, // Add filter functionality if needed  

            ),
          ],
        ),
      ),
    );
  }
}

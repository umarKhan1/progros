import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progros/logic/bottom_nav/bottom_state.dart';

class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  BottomNavigationCubit() : super(BottomNavigationState.initial());

  void onTabTapped(int tapped) {
    if (tapped == state.index) {
      final keys = [...state.pageKeys];
      keys[tapped] = UniqueKey(); 
      emit(state.copyWith(pageKeys: keys));
    } else {
      emit(state.copyWith(index: tapped));
    }
  }
}

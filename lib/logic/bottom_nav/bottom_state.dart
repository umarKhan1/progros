import 'package:flutter/material.dart';

class BottomNavigationState {
  const BottomNavigationState({required this.index, required this.pageKeys});

  factory BottomNavigationState.initial() => BottomNavigationState(
    index: 0,
    pageKeys: List.generate(4, (_) => UniqueKey()),
  );
  final int index;
  final List<UniqueKey> pageKeys;

  BottomNavigationState copyWith({int? index, List<UniqueKey>? pageKeys}) {
    return BottomNavigationState(
      index: index ?? this.index,
      pageKeys: pageKeys ?? this.pageKeys,
    );
  }
}

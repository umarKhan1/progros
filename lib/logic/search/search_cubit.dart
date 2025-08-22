import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progros/logic/search/search_state.dart';
import 'package:progros/models/product_model.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this.allProducts) : super(const SearchState());
  // supplier gives latest all products from ProductsCubit
  final List<Product> Function() allProducts;

  Timer? _debounce;

  void init() {}

  void onQueryChanged(String value) {
    _debounce?.cancel();
    emit(
      state.copyWith(
        query: value,
        phase: SearchPhase.typing,
        results: const [],
      ),
    );
    if (value.isEmpty) return;
    _debounce = Timer(const Duration(milliseconds: 300), () => search(value));
  }

  Future<void> search(String q) async {
    final term = q.trim();
    if (term.isEmpty) return;
    emit(state.copyWith(phase: SearchPhase.loading));
    try {
      await Future<void>.delayed(const Duration(milliseconds: 150));
      final lq = term.toLowerCase();
      final items = allProducts()
          .where((p) => p.title.toLowerCase().contains(lq))
          .toList();
      final recents = _addRecent(term, state.recent);
      emit(
        state.copyWith(
          phase: SearchPhase.results,
          results: items,
          recent: recents,
        ),
      );
    } catch (e) {
      emit(state.copyWith(phase: SearchPhase.error, error: e.toString()));
    }
  }

  void clearQuery() {
    emit(state.copyWith(query: '', phase: SearchPhase.idle, results: const []));
  }

  void removeRecent(String term) {
    final next = List<String>.from(state.recent)..remove(term);
    emit(state.copyWith(recent: next));
  }

  List<String> _addRecent(String term, List<String> current) {
    final next = [
      term,
      ...current.where((t) => t.toLowerCase() != term.toLowerCase()),
    ];
    return next.take(10).toList();
  }
}

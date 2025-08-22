import 'package:equatable/equatable.dart';
import 'package:progros/models/product_model.dart';

enum SearchPhase { idle, typing, loading, results, error }

class SearchState extends Equatable {

  const SearchState({
    this.query = '',
    this.phase = SearchPhase.idle,
    this.recent = const [],
    this.results = const [],
    this.error,
  });
  final String query;
  final SearchPhase phase;
  final List<String> recent;
  final List<Product> results;
  final String? error;

  bool get showRecentAndTrending => query.isEmpty && (phase == SearchPhase.idle
   || phase == SearchPhase.typing);

  SearchState copyWith({
    String? query,
    SearchPhase? phase,
    List<String>? recent,
    List<Product>? results,
    String? error,
  }) {
    return SearchState(
      query: query ?? this.query,
      phase: phase ?? this.phase,
      recent: recent ?? this.recent,
      results: results ?? this.results,
      error: error,
    );
  }

  @override
  List<Object?> get props => [query, phase, recent, results, error];
}

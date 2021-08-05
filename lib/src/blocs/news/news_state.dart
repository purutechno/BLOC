import 'package:equatable/equatable.dart';
import 'package:ioesolutions/src/models/news_model.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class NewsFailure extends NewsState {
  final String error;
  const NewsFailure({this.error});
  @override
  List<Object> get props => [error];
}

class NewsLoaded extends NewsState {
  final List<News> news;
  final bool hasReachedMax;

  const NewsLoaded({
    this.news,
    this.hasReachedMax,
  });

  NewsLoaded copyWith({
    List<News> news,
    bool hasReachedMax,
  }) {
    return NewsLoaded(
      news: news ?? this.news,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [news, hasReachedMax];

  @override
  String toString() =>
      'NewsLoaded { news: ${news.length}, hasReachedMax: $hasReachedMax }';
}

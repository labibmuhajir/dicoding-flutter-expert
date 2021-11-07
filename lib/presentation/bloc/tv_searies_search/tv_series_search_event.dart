part of 'tv_series_search_bloc.dart';

abstract class TvSeriesSearchEvent extends Equatable {
  const TvSeriesSearchEvent();

  @override
  List<Object> get props => [];
}

class OnQueryTvSeriesChanged extends TvSeriesSearchEvent {
  final String query;

  OnQueryTvSeriesChanged(this.query);

  @override
  List<Object> get props => [query];
}

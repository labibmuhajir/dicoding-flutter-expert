part of 'top_rated_tv_series_bloc.dart';

abstract class TopRatedTvSeriesState extends Equatable {
  const TopRatedTvSeriesState();
  
  @override
  List<Object> get props => [];
}

class TopRatedTvSeriesInitial extends TopRatedTvSeriesState {}

class TopRatedTvSeriesLoading extends TopRatedTvSeriesState {}

class TopRatedTvSeriesSuccess extends TopRatedTvSeriesState {
  final List<IdPosterTitleOverview> tvSeries;

  TopRatedTvSeriesSuccess(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class TopRatedTvSeriesError extends TopRatedTvSeriesState {
  final String message;
  final Function() retry;

  TopRatedTvSeriesError(this.message, {required this.retry});

  @override
  List<Object> get props => [message];
}

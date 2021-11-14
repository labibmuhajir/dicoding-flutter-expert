part of 'on_the_air_tv_series_bloc.dart';

abstract class OnTheAirTvSeriesState extends Equatable {
  const OnTheAirTvSeriesState();

  @override
  List<Object> get props => [];
}

class OnTheAirTvSeriesInitial extends OnTheAirTvSeriesState {}

class OnTheAirTvSeriesLoading extends OnTheAirTvSeriesState {}

class OnTheAirTvSeriesSuccess extends OnTheAirTvSeriesState {
  final List<IdPosterDataType> tvSeries;

  OnTheAirTvSeriesSuccess(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class OnTheAirTvSeriesError extends OnTheAirTvSeriesState {
  final String message;
  final Function retry;

  OnTheAirTvSeriesError(this.message, {required this.retry});

  @override
  List<Object> get props => [message];
}

part of 'now_playing_movie_bloc.dart';

abstract class NowPlayingMovieState extends Equatable {
  const NowPlayingMovieState();

  @override
  List<Object> get props => [];
}

class NowPlayingMovieInitial extends NowPlayingMovieState {}

class NowPlayingMovieLoading extends NowPlayingMovieState {}

class NowPlayingMovieSuccess extends NowPlayingMovieState {
  final List<IdPosterDataType> movies;

  NowPlayingMovieSuccess(this.movies);

  @override
  List<Object> get props => [movies];
}

class NowPlayingMovieError extends NowPlayingMovieState {
  final String message;
  final Function retry;

  NowPlayingMovieError(this.message, {required this.retry});

  @override
  List<Object> get props => [message];
}

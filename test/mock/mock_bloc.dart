import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_movie/popular_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_movie/top_rated_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_status/watchlist_status_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class MovieDetailStateFake extends Fake implements MovieDetailState {}

class MovieDetailEventFake extends Fake implements MovieDetailEvent {}

class MockWatchListStatusBloc
    extends MockBloc<WatchlistStatusEvent, WatchlistStatusState>
    implements WatchlistStatusBloc {}

class WatchListStatusStateFake extends Fake implements WatchlistStatusState {}

class WatchListStatusEventFake extends Fake implements WatchlistStatusEvent {}

class MockPopularMovieBloc
    extends MockBloc<PopularMovieEvent, PopularMovieState>
    implements PopularMovieBloc {}

class PopularMovieStateFake extends Fake implements PopularMovieState {}

class PopularMovieEventFake extends Fake implements PopularMovieEvent {}

class MockTopRatedMovieBloc
    extends MockBloc<TopRatedMovieEvent, TopRatedMovieState>
    implements TopRatedMovieBloc {}

class TopRatedMovieStateFake extends Fake implements TopRatedMovieState {}

class TopRatedMovieEventFake extends Fake implements TopRatedMovieEvent {}

class MockWatchlistBloc extends MockBloc<WatchlistEvent, WatchlistState>
    implements WatchlistBloc {}

class WatchlistStateFake extends Fake implements WatchlistState {}

class WatchlistEventFake extends Fake implements WatchlistEvent {}

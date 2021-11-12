import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/presentation/bloc/now_playing_movie/now_playing_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../provider/movie_list_notifier_test.mocks.dart';

void main() {
  late GetNowPlayingMovies getNowPlayingMovies;
  late NowPlayingMovieBloc bloc;

  setUp(() {
    getNowPlayingMovies = MockGetNowPlayingMovies();
    bloc = NowPlayingMovieBloc(getNowPlayingMovies);
  });

  final tMovieModel = testMovie;
  final tMovieList = [tMovieModel];
  final expected =
      tMovieList.map((e) => IdPosterTitleOverview.fromMovie(e)).toList();

  test('inital state should be initial', () {
    expect(bloc.state, NowPlayingMovieInitial());
  });

  blocTest('Should emit [Loading, Success] when data is gotten succesful',
      build: () {
        when(getNowPlayingMovies.execute())
            .thenAnswer((realInvocation) async => Right(tMovieList));

        return bloc;
      },
      act: (NowPlayingMovieBloc bloc) =>
          bloc.add(OnNowPlayingMovieDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () =>
          [NowPlayingMovieLoading(), NowPlayingMovieSuccess(expected)],
      verify: (NowPlayingMovieBloc bloc) {
        verify(getNowPlayingMovies.execute());
      });

  blocTest('Should emit [Loading, Error] when data is unsuccesful',
      build: () {
        when(getNowPlayingMovies.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure()));

        return bloc;
      },
      act: (NowPlayingMovieBloc bloc) =>
          bloc.add(OnNowPlayingMovieDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
            NowPlayingMovieLoading(),
            NowPlayingMovieError('Server Failure', retry: () {})
          ],
      verify: (NowPlayingMovieBloc bloc) {
        verify(getNowPlayingMovies.execute());
      });
}

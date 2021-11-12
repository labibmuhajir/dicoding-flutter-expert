import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/popular_movie/popular_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../provider/popular_movies_notifier_test.mocks.dart';

void main() {
  late GetPopularMovies getPopularMovies;
  late PopularMovieBloc bloc;

  setUp(() {
    getPopularMovies = MockGetPopularMovies();
    bloc = PopularMovieBloc(getPopularMovies);
  });

  final tMovie = testMovie;
  final tMovieList = <Movie>[tMovie];
  final expected =
      tMovieList.map((e) => IdPosterTitleOverview.fromMovie(e)).toList();

  test('inital state should be initial', () {
    expect(bloc.state, PopularMovieInitial());
  });

  blocTest('Should emit [Loading, HasData] when data is gotten succesful',
      build: () {
        when(getPopularMovies.execute())
            .thenAnswer((realInvocation) async => Right(tMovieList));

        return bloc;
      },
      act: (PopularMovieBloc bloc) => bloc.add(OnPopularMovieDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () => [PopularMovieLoading(), PopularMovieSuccess(expected)],
      verify: (PopularMovieBloc bloc) {
        verify(getPopularMovies.execute());
      });

  blocTest('Should emit [Loading, Error] when data is gotten succesful',
      build: () {
        when(getPopularMovies.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure()));

        return bloc;
      },
      act: (PopularMovieBloc bloc) => bloc.add(OnPopularMovieDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
            PopularMovieLoading(),
            PopularMovieError('Server Failure', retry: () {})
          ],
      verify: (PopularMovieBloc bloc) {
        verify(getPopularMovies.execute());
      });
}

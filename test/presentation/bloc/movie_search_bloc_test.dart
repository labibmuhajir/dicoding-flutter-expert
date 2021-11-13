import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MovieSearchBloc movieSearchBloc;
  late SearchMovies searchMovies;

  setUp(() {
    searchMovies = MockSearchMovies();
    movieSearchBloc = MovieSearchBloc(searchMovies);
  });

  final tMovieModel = testMovie;
  final tMovieList = <Movie>[tMovieModel];
  final tQuery = 'spiderman';

  test('inital state should be initial', () {
    expect(movieSearchBloc.state, MovieSearchInitial());
  });

  blocTest('Should emit [Loading, HasData] when data is gotten succesful',
      build: () {
        when(searchMovies.execute(tQuery))
            .thenAnswer((realInvocation) async => Right(tMovieList));

        return movieSearchBloc;
      },
      act: (MovieSearchBloc bloc) => bloc.add(OnQueryMovieChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [MovieSearchLoading(), MovieSearchHasData(tMovieList)],
      verify: (MovieSearchBloc bloc) {
        verify(searchMovies.execute(tQuery));
      });

  blocTest(
    'Should emit [Initial] when query is empty',
    build: () => movieSearchBloc,
    act: (MovieSearchBloc bloc) => bloc.add(OnQueryMovieChanged('')),
    wait: const Duration(milliseconds: 500),
    expect: () => [MovieSearchInitial()],
  );

  blocTest('Should emit [Loading, Empty] when data is gotten succesful',
      build: () {
        when(searchMovies.execute(tQuery))
            .thenAnswer((realInvocation) async => Right([]));

        return movieSearchBloc;
      },
      act: (MovieSearchBloc bloc) => bloc.add(OnQueryMovieChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () =>
          [MovieSearchLoading(), MovieSearchEmpty('No movie found $tQuery')],
      verify: (MovieSearchBloc bloc) {
        verify(searchMovies.execute(tQuery));
      });

  blocTest('Should emit [Loading, Error] when data is unsuccesful',
      build: () {
        when(searchMovies.execute(tQuery))
            .thenAnswer((realInvocation) async => Left(ServerFailure()));

        return movieSearchBloc;
      },
      act: (MovieSearchBloc bloc) => bloc.add(OnQueryMovieChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
            MovieSearchLoading(),
            MovieSearchError('Server Failure', retry: () {})
          ],
      verify: (MovieSearchBloc bloc) {
        verify(searchMovies.execute(tQuery));
      });
}

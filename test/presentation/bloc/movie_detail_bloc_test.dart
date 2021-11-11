import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/content_data.dart';
import 'package:ditonton/domain/entities/id_poster_data_type.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../provider/movie_detail_notifier_test.mocks.dart';

void main() {
  late GetMovieDetail getMovieDetail;
  late GetMovieRecommendations getMovieRecommendations;
  late MovieDetailBloc bloc;

  setUp(() {
    getMovieDetail = MockGetMovieDetail();
    getMovieRecommendations = MockGetMovieRecommendations();
    bloc = MovieDetailBloc(getMovieDetail, getMovieRecommendations);
  });

  final movieDetail = testMovieDetail;
  final tId = movieDetail.id;
  final expected = ContentData.fromMovie(movieDetail);
  final recommendation = [testMovie];
  final expectedRecommendation =
      recommendation.map((e) => IdPosterDataType.fromMovie(e)).toList();

  test('inital state should be initial', () {
    expect(bloc.state, MovieDetailInitial());
  });

  blocTest('Should emit [Loading, Success] when data is gotten succesful',
      build: () {
        when(getMovieDetail.execute(tId))
            .thenAnswer((realInvocation) async => Right(movieDetail));
        when(getMovieRecommendations.execute(tId))
            .thenAnswer((realInvocation) async => Right(recommendation));

        return bloc;
      },
      act: (MovieDetailBloc bloc) => bloc.add(OnMovieDetailDataRequested(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
            MovieDetailLoading(),
            MovieDetailSuccess(expected,
                recommendations: expectedRecommendation)
          ],
      verify: (MovieDetailBloc bloc) {
        verify(getMovieDetail.execute(tId));
        verify(getMovieRecommendations.execute(tId));
      });

  blocTest(
      'Should emit [Loading, ErrorRecommendation, Success] when data is gotten succesful',
      build: () {
        when(getMovieDetail.execute(tId))
            .thenAnswer((realInvocation) async => Right(movieDetail));
        when(getMovieRecommendations.execute(tId))
            .thenAnswer((realInvocation) async => Left(ServerFailure()));

        return bloc;
      },
      act: (MovieDetailBloc bloc) => bloc.add(OnMovieDetailDataRequested(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
            MovieDetailLoading(),
            MovieDetailError('Server Failure', retry: () {}),
            MovieDetailSuccess(expected)
          ],
      verify: (MovieDetailBloc bloc) {
        verify(getMovieDetail.execute(tId));
        verify(getMovieRecommendations.execute(tId));
      });

  blocTest('Should emit [Loading, Success] when data is gotten succesful',
      build: () {
        when(getMovieRecommendations.execute(tId))
            .thenAnswer((realInvocation) async => Right(recommendation));

        return bloc;
      },
      act: (MovieDetailBloc bloc) =>
          bloc.add(OnMovieRecommendationsRequested(expected)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
            MovieDetailLoading(),
            MovieDetailSuccess(expected,
                recommendations: expectedRecommendation)
          ],
      verify: (MovieDetailBloc bloc) {
        verify(getMovieRecommendations.execute(tId));
      });
}

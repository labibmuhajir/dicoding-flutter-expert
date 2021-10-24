import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/id_poster_data_type.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/provider/tv_series_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_list_notifier_test.mocks.dart';

@GenerateMocks([GetOnTheAirTvSeries, GetPopularTvSeries, GetTopRatedTvSeries])
void main() {
  late GetOnTheAirTvSeries getOnTheAirTvSeries;
  late GetPopularTvSeries getPopularTvSeries;
  late GetTopRatedTvSeries getTopRatedTvSeries;
  late TvSeriesListNotifier provider;

  setUp(() {
    getOnTheAirTvSeries = MockGetOnTheAirTvSeries();
    getPopularTvSeries = MockGetPopularTvSeries();
    getTopRatedTvSeries = MockGetTopRatedTvSeries();
    provider = TvSeriesListNotifier(
        getOnTheAirTvSeries: getOnTheAirTvSeries,
        getPopularTvSeries: getPopularTvSeries,
        getTopRatedTvSeries: getTopRatedTvSeries);
  });

  group('On The Air TvSeries', () {
    test('initial tv series must be empty', () {
      final expected = [];
      expect(provider.onTheAirTvSeries, expected);
    });

    test('should get data from the usecase', () async {
      // arrange
      when(getOnTheAirTvSeries.execute())
          .thenAnswer((_) async => Right(tOnTheAirTvSeriesList));
      // act
      provider.fetchOnTheAirTvSeries();
      // assert
      verify(getOnTheAirTvSeries.execute());
    });

    test('should change state to Loading when usecase is called', () async {
      // arrange
      when(getOnTheAirTvSeries.execute())
          .thenAnswer((_) async => Right(tOnTheAirTvSeriesList));
      // act
      provider.fetchOnTheAirTvSeries();
      // assert
      expect(provider.onTheAirState, RequestState.Loading);
    });

    test('should change movies when data is gotten successfully', () async {
      // arrange
      final data = tOnTheAirTvSeriesList;
      final expected = data.map((e) => IdPosterDataType.fromTvSeries(e));
      when(getOnTheAirTvSeries.execute()).thenAnswer((_) async => Right(data));
      // act
      await provider.fetchOnTheAirTvSeries();
      // assert
      expect(provider.onTheAirState, RequestState.Loaded);
      expect(provider.onTheAirTvSeries, expected);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(getOnTheAirTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure()));
      // act
      await provider.fetchOnTheAirTvSeries();
      // assert
      expect(provider.onTheAirState, RequestState.Error);
      expect(provider.message, 'Server Failure');
    });
  });

  group('Popular TvSeries', () {
    test('initial tv series must be empty', () {
      final expected = [];
      expect(provider.popularTvSeries, expected);
    });

    test('should get data from the usecase', () async {
      // arrange
      when(getPopularTvSeries.execute())
          .thenAnswer((_) async => Right(tPopularTvSeriesList));
      // act
      provider.fetchPopularTvSeries();
      // assert
      verify(getPopularTvSeries.execute());
    });

    test('should change state to Loading when usecase is called', () async {
      // arrange
      when(getPopularTvSeries.execute())
          .thenAnswer((_) async => Right(tPopularTvSeriesList));
      // act
      provider.fetchPopularTvSeries();
      // assert
      expect(provider.popularState, RequestState.Loading);
    });

    test('should change movies when data is gotten successfully', () async {
      // arrange
      final data = tPopularTvSeriesList;
      final expected = data.map((e) => IdPosterDataType.fromTvSeries(e));
      when(getPopularTvSeries.execute()).thenAnswer((_) async => Right(data));
      // act
      await provider.fetchPopularTvSeries();
      // assert
      expect(provider.popularState, RequestState.Loaded);
      expect(provider.popularTvSeries, expected);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(getPopularTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure()));
      // act
      await provider.fetchPopularTvSeries();
      // assert
      expect(provider.popularState, RequestState.Error);
      expect(provider.message, 'Server Failure');
    });
  });

  group('Top Rated TvSeries', () {
    test('initial top rated tv series must be empty', () {
      final expected = [];
      expect(provider.topRatedTvSeries, expected);
    });

    test('should get data from the usecase', () async {
      // arrange
      when(getTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(tTopRatedSeriesList));
      // act
      provider.fetchTopRatedTvSeries();
      // assert
      verify(getTopRatedTvSeries.execute());
    });

    test('should change state to Loading when usecase is called', () async {
      // arrange
      when(getTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(tTopRatedSeriesList));
      // act
      provider.fetchTopRatedTvSeries();
      // assert
      expect(provider.topRatedState, RequestState.Loading);
    });

    test('should change movies when data is gotten successfully', () async {
      // arrange
      final data = tTopRatedSeriesList;
      final expected = data.map((e) => IdPosterDataType.fromTvSeries(e));
      when(getTopRatedTvSeries.execute()).thenAnswer((_) async => Right(data));
      // act
      await provider.fetchTopRatedTvSeries();
      // assert
      expect(provider.topRatedState, RequestState.Loaded);
      expect(provider.topRatedTvSeries, expected);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(getPopularTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure()));
      // act
      await provider.fetchPopularTvSeries();
      // assert
      expect(provider.popularState, RequestState.Error);
      expect(provider.message, 'Server Failure');
    });
  });
}

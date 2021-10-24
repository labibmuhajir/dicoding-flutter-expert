import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/provider/tv_series_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late TvSeriesSearchNotifier provider;
  late SearchTvSeries searchTvSeries;

  setUp(() {
    searchTvSeries = MockSearchTvSeries();
    provider = TvSeriesSearchNotifier(searchTvSeries: searchTvSeries);
  });
  final tQuery = 'spiderman';

  group('search movies', () {
    final data = tSearchTvSeriesList;
    final expected = tSearchTvSeriesList
        .map((e) => IdPosterTitleOverview.fromTvSeries(e))
        .toList();

    test('should change state to loading when usecase is called', () async {
      // arrange
      when(searchTvSeries.execute(tQuery)).thenAnswer((_) async => Right(data));
      // act
      provider.fetchTvSeriesSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully',
        () async {
      // arrange
      when(searchTvSeries.execute(tQuery)).thenAnswer((_) async => Right(data));
      // act
      await provider.fetchTvSeriesSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loaded);
      expect(provider.searchResult, expected);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(searchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure()));
      // act
      await provider.fetchTvSeriesSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
    });
  });
}

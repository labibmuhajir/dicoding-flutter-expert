import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTvSeries usecase;
  late TvSeriesRepository repository;

  setUp(() {
    repository = MockTvSeriesRepository();
    usecase = SearchTvSeries(repository);
  });

  final tQuery = 'phoenix';

  test('should get list of movies from the repository', () async {
    // arrange
    final expected = tSearchTvSeriesList;
    when(repository.searchTvSeries(tQuery))
        .thenAnswer((_) async => Right(expected));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(expected));
  });
}

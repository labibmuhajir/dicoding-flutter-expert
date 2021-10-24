import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedTvSeries useCase;
  late TvSeriesRepository repository;

  setUp(() {
    repository = MockTvSeriesRepository();
    useCase = GetTopRatedTvSeries(repository);
  });
  group('get top rated tv series', () {
    test('should return Top Rated List TvSeries', () async {
      //arrange
      final expected = tTopRatedSeriesList;

      when(repository.getTopRatedTvSeries())
          .thenAnswer((_) async => Right(expected));

      //act
      final actual = await useCase.execute();

      //assert
      verify(repository.getTopRatedTvSeries());
      expect(actual, Right(expected));
    });
  });
}

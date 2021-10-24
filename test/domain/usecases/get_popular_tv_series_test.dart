import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTvSeries useCase;
  late TvSeriesRepository repository;

  setUp(() {
    repository = MockTvSeriesRepository();
    useCase = GetPopularTvSeries(repository);
  });
  group('get popular tv series', () {
    test('should return Popular List TvSeries', () async {
      //arrange
      final expected = tPopularTvSeriesList;

      when(repository.getPopularTvSeries())
          .thenAnswer((_) async => Right(expected));

      //act
      final actual = await useCase.execute();

      //assert
      verify(repository.getPopularTvSeries());
      expect(actual, Right(expected));
    });
  });
}

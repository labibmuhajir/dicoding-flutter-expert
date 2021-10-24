import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetOnTheAirTvSeries useCase;
  late TvSeriesRepository repository;

  setUp(() {
    repository = MockTvSeriesRepository();
    useCase = GetOnTheAirTvSeries(repository);
  });
  group('get on the air tv series', () {
    test('should return On The Air List TvSeries', () async {
      //arrange
      final expected = tOnTheAirTvSeriesList;

      when(repository.getOnTheAirTvSeries())
          .thenAnswer((_) async => Right(expected));

      //act
      final actual = await useCase.execute();

      //assert
      verify(repository.getOnTheAirTvSeries());
      expect(actual, Right(expected));
    });
  });
}

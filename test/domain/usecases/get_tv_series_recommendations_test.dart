import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesRecommendations usecase;
  late TvSeriesRepository repository;

  setUp(() {
    repository = MockTvSeriesRepository();
    usecase = GetTvSeriesRecommendations(repository);
  });

  final tId = tTvDetail.id;

  test('should get list of tv series recommendations from the repository',
      () async {
    // arrange
    final response = tTvRecommendationList;
    when(repository.getTvSeriesRecommendation(tId))
        .thenAnswer((_) async => Right(response));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(response));
  });
}

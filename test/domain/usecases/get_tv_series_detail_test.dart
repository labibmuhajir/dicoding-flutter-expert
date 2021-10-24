import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesDetail usecase;
  late TvSeriesRepository repository;

  setUp(() {
    repository = MockTvSeriesRepository();
    usecase = GetTvSeriesDetail(repository);
  });

  final tId = tTvDetail.id;

  test('should get tv series detail from the repository', () async {
    // arrange
    final response = tTvDetail;

    when(repository.getTvSeries(tId)).thenAnswer((_) async => Right(response));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(response));
  });
}

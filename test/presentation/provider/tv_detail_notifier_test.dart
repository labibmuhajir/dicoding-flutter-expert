import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/content_data.dart';
import 'package:ditonton/domain/entities/id_poster_data_type.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_notifier_test.mocks.dart';

@GenerateMocks([GetTvSeriesDetail, GetTvSeriesRecommendations])
void main() {
  late TvDetailNotifier provider;
  late GetTvSeriesDetail getTvSeriesDetail;
  late GetTvSeriesRecommendations getTvSeriesRecommendations;

  final detailData = tTvDetail;
  final tId = detailData.id;
  final detailExpected = ContentData.fromTvSeries(detailData);
  final recommendationData = tTvRecommendationList;
  final recommendationExpected =
      recommendationData.map((e) => IdPosterDataType.fromTvSeries(e)).toList();

  setUp(() {
    getTvSeriesDetail = MockGetTvSeriesDetail();
    getTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    provider = TvDetailNotifier(
        getTvSeriesDetail: getTvSeriesDetail,
        getTvSeriesRecommendations: getTvSeriesRecommendations);
  });

  void _arrangeUsecase() {
    when(getTvSeriesDetail.execute(tId))
        .thenAnswer((_) async => Right(detailData));
    when(getTvSeriesRecommendations.execute(tId))
        .thenAnswer((realInvocation) async => Right(recommendationData));
  }

  group('Get Tv Series Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvDetail(tId);
      // assert
      verify(getTvSeriesDetail.execute(tId));
      verify(getTvSeriesRecommendations.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      provider.fetchTvDetail(tId);
      // assert
      expect(provider.tvSeriesState, RequestState.Loading);
      expect(provider.recommendationState, RequestState.Loading);
    });

    test('should change movie when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvDetail(tId);
      // assert
      expect(provider.tvSeriesState, RequestState.Loaded);
      expect(provider.tvSeries, detailExpected);
      expect(provider.recommendationState, RequestState.Loaded);
      expect(provider.recommendations, recommendationExpected);
    });
  });
}

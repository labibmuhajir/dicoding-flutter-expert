import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/content_data.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_notifier_test.mocks.dart';

@GenerateMocks([GetTvSeriesDetail])
void main() {
  late TvDetailNotifier provider;
  late GetTvSeriesDetail getTvSeriesDetail;

  final data = tTvDetail;
  final tId = data.id;
  final expected = ContentData.fromTvSeries(data);

  setUp(() {
    getTvSeriesDetail = MockGetTvSeriesDetail();
    provider = TvDetailNotifier(getTvSeriesDetail: getTvSeriesDetail);
  });

  void _arrangeUsecase() {
    when(getTvSeriesDetail.execute(tId))
        .thenAnswer((_) async => Right(tTvDetail));
  }

  group('Get Tv Series Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvDetail(tId);
      // assert
      verify(getTvSeriesDetail.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      provider.fetchTvDetail(tId);
      // assert
      expect(provider.tvSeriesState, RequestState.Loading);
    });

    test('should change movie when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvDetail(tId);
      // assert
      expect(provider.tvSeriesState, RequestState.Loaded);
      expect(provider.tvSeries, expected);
    });
  });
}

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/presentation/provider/popular_tv_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_list_notifier_test.mocks.dart';

@GenerateMocks([GetPopularTvSeries])
void main() {
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late PopularTvSeriesNotifier notifier;

  setUp(() {
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    notifier =
        PopularTvSeriesNotifier(getPopularTvSeries: mockGetPopularTvSeries);
  });

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetPopularTvSeries.execute())
        .thenAnswer((_) async => Right(tOnTheAirTvSeriesList));
    // act
    notifier.fetchPopularTvSeries();
    // assert
    expect(notifier.state, RequestState.Loading);
  });

  test('should change tv series data when data is gotten successfully',
      () async {
    final data = tPopularTvSeriesList;
    final expected = data.map((e) => IdPosterTitleOverview.fromTvSeries(e));
    // arrange
    when(mockGetPopularTvSeries.execute()).thenAnswer((_) async => Right(data));
    // act
    await notifier.fetchPopularTvSeries();
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.popularTvSeries, expected);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetPopularTvSeries.execute())
        .thenAnswer((_) async => Left(ServerFailure()));
    // act
    await notifier.fetchPopularTvSeries();
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
  });
}

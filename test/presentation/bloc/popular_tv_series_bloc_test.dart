import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/presentation/bloc/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../provider/tv_series_list_notifier_test.mocks.dart';

void main() {
  late GetPopularTvSeries getPopularTvSeries;
  late PopularTvSeriesBloc bloc;

  setUp(() {
    getPopularTvSeries = MockGetPopularTvSeries();
    bloc = PopularTvSeriesBloc(getPopularTvSeries);
  });

  final data = tOnTheAirTvSeriesList;
  final expected = data.map((e) => IdPosterTitleOverview.fromTvSeries(e)).toList();

  test('inital state should be initial', () {
    expect(bloc.state, PopularTvSeriesInitial());
  });

  blocTest('Should emit [Loading, HasData] when data is gotten succesful',
      build: () {
        when(getPopularTvSeries.execute())
            .thenAnswer((realInvocation) async => Right(data));

        return bloc;
      },
      act: (PopularTvSeriesBloc bloc) => bloc.add(OnPopulartTvSeriesDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () => [PopularTvSeriesLoading(), PopularTvSeriesSuccess(expected)],
      verify: (PopularTvSeriesBloc bloc) {
        verify(getPopularTvSeries.execute());
      });

      blocTest('Should emit [Loading, Error] when data is gotten succesful',
      build: () {
        when(getPopularTvSeries.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure()));

        return bloc;
      },
      act: (PopularTvSeriesBloc bloc) => bloc.add(OnPopulartTvSeriesDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () => [PopularTvSeriesLoading(), PopularTvSeriesError('Server Failure', retry: () {})],
      verify: (PopularTvSeriesBloc bloc) {
        verify(getPopularTvSeries.execute());
      });
}
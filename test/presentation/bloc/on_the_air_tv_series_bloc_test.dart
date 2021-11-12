import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:ditonton/presentation/bloc/on_the_air_tv_series/on_the_air_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../provider/tv_series_list_notifier_test.mocks.dart';

void main() {
  late GetOnTheAirTvSeries getOnTheAirTvSeries;
  late OnTheAirTvSeriesBloc bloc;

  setUp(() {
    getOnTheAirTvSeries = MockGetOnTheAirTvSeries();
    bloc = OnTheAirTvSeriesBloc(getOnTheAirTvSeries);
  });

  final data = tOnTheAirTvSeriesList;
  final expected = data.map((e) => IdPosterTitleOverview.fromTvSeries(e)).toList();

  test('inital state should be initial', () {
    expect(bloc.state, OnTheAirTvSeriesInitial());
  });

  blocTest('Should emit [Loading, Success] when data is gotten succesful',
      build: () {
        when(getOnTheAirTvSeries.execute())
            .thenAnswer((realInvocation) async => Right(data));

        return bloc;
      },
      act: (OnTheAirTvSeriesBloc bloc) => bloc.add(OnTheAirTvSeriesDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () => [OnTheAirTvSeriesLoading(), OnTheAirTvSeriesSuccess(expected)],
      verify: (OnTheAirTvSeriesBloc bloc) {
        verify(getOnTheAirTvSeries.execute());
      });

      blocTest('Should emit [Loading, Error] when data is gotten succesful',
      build: () {
        when(getOnTheAirTvSeries.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure()));

        return bloc;
      },
      act: (OnTheAirTvSeriesBloc bloc) => bloc.add(OnTheAirTvSeriesDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () => [OnTheAirTvSeriesLoading(), OnTheAirTvSeriesError('Server Failure', retry: () {})],
      verify: (OnTheAirTvSeriesBloc bloc) {
        verify(getOnTheAirTvSeries.execute());
      });
}
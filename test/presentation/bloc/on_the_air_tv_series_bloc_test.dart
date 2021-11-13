import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/id_poster_data_type.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:ditonton/presentation/bloc/on_the_air_tv_series/on_the_air_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'on_the_air_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetOnTheAirTvSeries])
void main() {
  late GetOnTheAirTvSeries getOnTheAirTvSeries;
  late OnTheAirTvSeriesBloc bloc;

  setUp(() {
    getOnTheAirTvSeries = MockGetOnTheAirTvSeries();
    bloc = OnTheAirTvSeriesBloc(getOnTheAirTvSeries);
  });

  final data = tOnTheAirTvSeriesList;
  final expected = data.map((e) => IdPosterDataType.fromTvSeries(e)).toList();

  test('inital state should be initial', () {
    expect(bloc.state, OnTheAirTvSeriesInitial());
  });

  blocTest('Should emit [Loading, Success] when data is gotten succesful',
      build: () {
        when(getOnTheAirTvSeries.execute())
            .thenAnswer((realInvocation) async => Right(data));

        return bloc;
      },
      act: (OnTheAirTvSeriesBloc bloc) =>
          bloc.add(OnTheAirTvSeriesDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () =>
          [OnTheAirTvSeriesLoading(), OnTheAirTvSeriesSuccess(expected)],
      verify: (OnTheAirTvSeriesBloc bloc) {
        verify(getOnTheAirTvSeries.execute());
      });

  blocTest('Should emit [Loading, Error] when data is gotten succesful',
      build: () {
        when(getOnTheAirTvSeries.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure()));

        return bloc;
      },
      act: (OnTheAirTvSeriesBloc bloc) =>
          bloc.add(OnTheAirTvSeriesDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
            OnTheAirTvSeriesLoading(),
            OnTheAirTvSeriesError('Server Failure', retry: () {})
          ],
      verify: (OnTheAirTvSeriesBloc bloc) {
        verify(getOnTheAirTvSeries.execute());
      });
}

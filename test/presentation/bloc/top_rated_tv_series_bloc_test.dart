import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../provider/tv_series_list_notifier_test.mocks.dart';

void main() {
  late GetTopRatedTvSeries getTopRatedTvSeries;
  late TopRatedTvSeriesBloc bloc;

  setUp(() {
    getTopRatedTvSeries = MockGetTopRatedTvSeries();
    bloc = TopRatedTvSeriesBloc(getTopRatedTvSeries);
  });

  final data = tOnTheAirTvSeriesList;
  final expected = data.map((e) => IdPosterTitleOverview.fromTvSeries(e)).toList();

   test('inital state should be initial', () {
    expect(bloc.state, TopRatedTvSeriesInitial());
  });

  blocTest('Should emit [Loading, HasData] when data is gotten succesful',
      build: () {
        when(getTopRatedTvSeries.execute())
            .thenAnswer((realInvocation) async => Right(data));

        return bloc;
      },
      act: (TopRatedTvSeriesBloc bloc) => bloc.add(OnTopRatedTvSeriesDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () => [TopRatedTvSeriesLoading(), TopRatedTvSeriesSuccess(expected)],
      verify: (TopRatedTvSeriesBloc bloc) {
        verify(getTopRatedTvSeries.execute());
      });

  blocTest('Should emit [Loading, Error] when server failure',
      build: () {
        when(getTopRatedTvSeries.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure()));

        return bloc;
      },
      act: (TopRatedTvSeriesBloc bloc) => bloc.add(OnTopRatedTvSeriesDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () => [TopRatedTvSeriesLoading(), TopRatedTvSeriesError('Server Failure', retry: () {})],
      verify: (TopRatedTvSeriesBloc bloc) {
        verify(getTopRatedTvSeries.execute());
      });
}
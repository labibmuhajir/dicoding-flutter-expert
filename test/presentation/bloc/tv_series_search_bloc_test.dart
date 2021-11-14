import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_searies_search/tv_series_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_search_bloc_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late TvSeriesSearchBloc bloc;
  late SearchTvSeries searchTvSeries;

  setUp(() {
    searchTvSeries = MockSearchTvSeries();
    bloc = TvSeriesSearchBloc(searchTvSeries);
  });

  final tQuery = 'spiderman';
  final data = tSearchTvSeriesList;
  final expected = tSearchTvSeriesList
      .map((e) => IdPosterTitleOverview.fromTvSeries(e))
      .toList();

  test('inital state should be empty', () {
    expect(bloc.state, TvSeriesSearchInitial());
  });

  blocTest('Should emit [Loading, HasData] when data is gotten succesful',
      build: () {
        when(searchTvSeries.execute(tQuery))
            .thenAnswer((realInvocation) async => Right(data));

        return bloc;
      },
      act: (TvSeriesSearchBloc bloc) =>
          bloc.add(OnQueryTvSeriesChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [TvSeriesSearchLoading(), TvSeriesSearchHasData(expected)],
      verify: (TvSeriesSearchBloc bloc) {
        verify(searchTvSeries.execute(tQuery));
      });

  blocTest(
    'Should emit [Initial] when query is empty',
    build: () => bloc,
    act: (TvSeriesSearchBloc bloc) => bloc.add(OnQueryTvSeriesChanged('')),
    wait: const Duration(milliseconds: 500),
    expect: () => [TvSeriesSearchInitial()],
  );

  blocTest('Should emit [Loading, Empty] when data is gotten succesful',
      build: () {
        when(searchTvSeries.execute(tQuery))
            .thenAnswer((realInvocation) async => Right([]));

        return bloc;
      },
      act: (TvSeriesSearchBloc bloc) =>
          bloc.add(OnQueryTvSeriesChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
            TvSeriesSearchLoading(),
            TvSeriesSearchEmpty('No Tv Series found $tQuery')
          ],
      verify: (TvSeriesSearchBloc bloc) {
        verify(searchTvSeries.execute(tQuery));
      });

  blocTest('Should emit [Loading, Error] when data is unsuccesful',
      build: () {
        when(searchTvSeries.execute(tQuery))
            .thenAnswer((realInvocation) async => Left(ServerFailure()));

        return bloc;
      },
      act: (TvSeriesSearchBloc bloc) =>
          bloc.add(OnQueryTvSeriesChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
            TvSeriesSearchLoading(),
            TvSeriesSearchError('Server Failure', retry: () {})
          ],
      verify: (TvSeriesSearchBloc bloc) {
        verify(searchTvSeries.execute(tQuery));
      });
}

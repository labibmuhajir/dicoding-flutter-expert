import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlist])
void main() {
  late GetWatchlist getWatchlist;
  late WatchlistBloc bloc;

  setUp(() {
    getWatchlist = MockGetWatchlist();

    bloc = WatchlistBloc(getWatchlist);
  });

  final data = [testWatchlistMovie];
  final expected = data.map((e) => IdPosterTitleOverview.fromMovie(e)).toList();

  test('inital state should be initial', () {
    expect(bloc.state, WatchlistInitial());
  });

  blocTest('Should emit [Loading, HasData] when data is gotten succesful',
      build: () {
        when(getWatchlist.execute())
            .thenAnswer((realInvocation) async => Right(expected));

        return bloc;
      },
      act: (WatchlistBloc bloc) => bloc.add(OnWatchlistDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () => [WatchlistLoading(), WatchlistHasData(expected)],
      verify: (WatchlistBloc bloc) {
        verify(getWatchlist.execute());
      });

  blocTest(
    'Should emit [Loading, Empty] when data is empty and succesful',
    build: () {
      when(getWatchlist.execute())
          .thenAnswer((realInvocation) async => Right([]));

      return bloc;
    },
    act: (WatchlistBloc bloc) => bloc.add(OnWatchlistDataRequested()),
    wait: const Duration(milliseconds: 500),
    expect: () => [WatchlistLoading(), WatchlistEmpty()],
  );
}

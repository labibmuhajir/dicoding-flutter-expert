import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/content_data.dart';
import 'package:ditonton/presentation/bloc/watchlist_status/watchlist_status_bloc.dart';
import 'package:ditonton/presentation/widgets/watchlist_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../mock/mock_bloc.dart';

void main() {
  late WatchlistStatusBloc bloc;

  setUp(() {
    bloc = MockWatchListStatusBloc();
  });

  setUpAll(() {
    registerFallbackValue(WatchListStatusStateFake());
    registerFallbackValue(WatchListStatusEventFake());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider.value(
      value: bloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  final data = testMovieDetail;
  final contentData = ContentData.fromMovie(data);

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    final isAddedToWatchList = false;

    whenListen(
        bloc,
        Stream.fromIterable([
          WatchlistStatusLoading(),
          WatchlistStatusLoaded(isAddedToWatchList)
        ]),
        initialState: WatchlistStatusInitial());

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(WatchlistButton(contentData)));
    await tester.pump(Duration.zero);

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    final isAddedToWatchList = true;

    whenListen(
        bloc,
        Stream.fromIterable([
          WatchlistStatusLoading(),
          WatchlistStatusLoaded(isAddedToWatchList)
        ]),
        initialState: WatchlistStatusInitial());

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(WatchlistButton(contentData)));
    await tester.pump(Duration.zero);

    expect(watchlistButtonIcon, findsOneWidget);
  });
}

import 'package:ditonton/domain/entities/content_data.dart';
import 'package:ditonton/presentation/provider/watchlist_notifier.dart';
import 'package:ditonton/presentation/widgets/watchlist_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_button_test.mocks.dart';

@GenerateMocks([WatchlistNotifier])
void main() {
  late WatchlistNotifier watchlistNotifier;

  setUp(() {
    watchlistNotifier = MockWatchlistNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider.value(
      value: watchlistNotifier,
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

    when(watchlistNotifier.isAddedToWatchlist).thenReturn(isAddedToWatchList);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(WatchlistButton(contentData)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    final isAddedToWatchList = true;

    when(watchlistNotifier.isAddedToWatchlist).thenReturn(isAddedToWatchList);

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(WatchlistButton(contentData)));

    expect(watchlistButtonIcon, findsOneWidget);
  });
}

import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/content_data.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_notifier.dart';
import 'package:ditonton/presentation/widgets/detail_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import '../widgets.dart/watchlist_button_test.mocks.dart';
import 'detail_content_test.mocks.dart';

void main() {
  late MovieDetailNotifier movieDetailNotifier;
  late WatchlistNotifier watchlistNotifier;

  setUp(() {
    movieDetailNotifier = MockMovieDetailNotifier();
    watchlistNotifier = MockWatchlistNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => movieDetailNotifier,
          ),
          ChangeNotifierProvider(
            create: (_) => watchlistNotifier,
          ),
        ],
        child: Builder(
          builder: (_) => MaterialApp(
            home: Scaffold(
              body: body,
            ),
          ),
        ));
  }

  final movieDetail = testMovieDetail;
  final movieRecommendation = <Movie>[];
  final contentData = ContentData.fromMovie(movieDetail);

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    final isAddedToWatchList = false;
    final message = 'Added to Watchlist';

    when(movieDetailNotifier.recommendationState)
        .thenReturn(RequestState.Loaded);
    when(movieDetailNotifier.movieRecommendations)
        .thenReturn(movieRecommendation);
    when(watchlistNotifier.isAddedToWatchlist).thenReturn(isAddedToWatchList);
    when(watchlistNotifier.message).thenReturn(message);

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(DetailContent(contentData)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(message), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    final isAddedToWatchList = false;
    final message = 'Failed';

    when(movieDetailNotifier.recommendationState)
        .thenReturn(RequestState.Loaded);
    when(movieDetailNotifier.movieRecommendations)
        .thenReturn(movieRecommendation);
    when(watchlistNotifier.isAddedToWatchlist).thenReturn(isAddedToWatchList);
    when(watchlistNotifier.message).thenReturn(message);

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(DetailContent(contentData)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text(message), findsOneWidget);
  });
}

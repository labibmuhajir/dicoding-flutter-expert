import 'package:ditonton/domain/entities/content_data.dart';
import 'package:ditonton/domain/entities/id_and_data_type.dart';
import 'package:ditonton/presentation/provider/watchlist_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistButton extends StatelessWidget {
  final ContentData contentData;

  WatchlistButton(this.contentData);

  @override
  Widget build(BuildContext context) {
    return Consumer<WatchlistNotifier>(
        builder: (context, notifier, child) => ElevatedButton(
              onPressed: () async {
                if (!notifier.isAddedToWatchlist) {
                  await notifier.addWatchlist(contentData);
                } else {
                  await notifier.removeFromWatchlist(
                      IdAndDataType(contentData.id, contentData.dataType));
                }

                final message = notifier.message;

                if (message == WatchlistNotifier.watchlistAddSuccessMessage ||
                    message ==
                        WatchlistNotifier.watchlistRemoveSuccessMessage) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(message)));
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(message),
                        );
                      });
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  notifier.isAddedToWatchlist
                      ? Icon(Icons.check)
                      : Icon(Icons.add),
                  Text('Watchlist'),
                ],
              ),
            ));
  }
}

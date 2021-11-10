import 'package:ditonton/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:ditonton/presentation/widgets/id_poster_title_overview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class WatchlistPage extends StatelessWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
      context.read<WatchlistBloc>()..add(OnWatchlistDataRequested());

      return Scaffold(
        appBar: AppBar(
          title: Text('Watchlist'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: state is WatchlistLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : state is WatchlistHasData
                    ? state.data.isNotEmpty
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              final watchlist = state.data[index];
                              return IdPosterTitleOverviewCard(watchlist);
                            },
                            itemCount: state.data.length,
                          )
                        : Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'No watchlist yet, you can add some from list movie or serial tv',
                                  textAlign: TextAlign.center,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Add Now'))
                              ],
                            ),
                          )
                    : Center(
                        key: Key('error_message'),
                        child: state is WatchlistError
                            ? Text(state.message)
                            : Container(),
                      )),
      );
    });
  }
}

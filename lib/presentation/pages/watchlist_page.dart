import 'package:ditonton/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:ditonton/presentation/widgets/ditonton_error_widget.dart';
import 'package:ditonton/presentation/widgets/id_poster_title_overview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class WatchlistPage extends StatelessWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  Widget build(BuildContext context) {
    context.read<WatchlistBloc>().add(OnWatchlistDataRequested());

    return Scaffold(
        appBar: AppBar(
          title: Text('Watchlist'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<WatchlistBloc, WatchlistState>(
              builder: (context, state) {
                if (state is WatchlistLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is WatchlistHasData) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final watchlist = state.data[index];
                      return IdPosterTitleOverviewCard(watchlist);
                    },
                    itemCount: state.data.length,
                  );
                } else if (state is WatchlistEmpty) {
                  return Center(
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
                  );
                } else if (state is WatchlistError) {
                  return Center(
                    key: Key('error_message'),
                    child: state is WatchlistError
                        ? DitontonErrorWidget(
                            state.message,
                            retry: state.retry,
                          )
                        : Container(),
                  );
                } else {
                  return Container();
                }
              },
            )));
  }
}

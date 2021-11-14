import 'package:ditonton/domain/entities/content_data.dart';
import 'package:ditonton/domain/entities/id_and_data_type.dart';
import 'package:ditonton/presentation/bloc/watchlist_status/watchlist_status_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class WatchlistButton extends StatelessWidget {
  final ContentData contentData;

  WatchlistButton(this.contentData);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WatchlistStatusBloc, WatchlistStatusState>(
      listener: (context, state) {
        if (state is WatchlistStatusSuccess) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is WatchlistStatusError) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    content: Text(
                  state.message,
                ));
              });
        }
      },
      builder: (BuildContext context, state) {
        final idAndDataType =
            IdAndDataType(contentData.id, contentData.dataType);
        context
            .read<WatchlistStatusBloc>()
            .add(OnWatchlistStatusChecked(idAndDataType));

        return ElevatedButton(
          onPressed: () async {
            if (state is WatchlistStatusLoaded) {
              context.read<WatchlistStatusBloc>().add(state.isAdded
                  ? OnWatchlistRemoved(idAndDataType)
                  : OnWatchlistAdded(contentData));
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state is WatchlistStatusLoaded)
                state.isAdded ? Icon(Icons.check) : Icon(Icons.add),
              Text('Watchlist'),
            ],
          ),
        );
      },
    );
  }
}

import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_searies_search/tv_series_search_bloc.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/widgets/id_poster_title_overview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';
  final HomeState state;

  SearchPage({this.state = HomeState.Movies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search ${state == HomeState.TvSeries ? 'Tv' : 'Movie'}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                if (state == HomeState.Movies) {
                  context
                      .read<MovieSearchBloc>()
                      .add(OnQueryMovieChanged(query));
                } else if (state == HomeState.TvSeries) {
                  context
                      .read<TvSeriesSearchBloc>()
                      .add(OnQueryTvSeriesChanged(query));
                }
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            if (state == HomeState.Movies) _buildMovieSearch(),
            if (state == HomeState.TvSeries) _buildTvSeriesSearch(),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieSearch() {
    return BlocBuilder<MovieSearchBloc, MovieSearchState>(
      builder: (context, state) {
        if (state is MovieSearchLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MovieSearchHasData) {
          final result = state.data;
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final movie = result[index];
                return IdPosterTitleOverviewCard.fromMovie(movie);
              },
              itemCount: result.length,
            ),
          );
        } else if (state is MovieSearchEmpty) {
          return Center(
            child: Text(state.message),
          );
        } else if (state is MovieSearchError) {
          return Center(
            child: state.retry != null
                ? Column(
                    children: [
                      Text(state.message),
                      ElevatedButton(
                          onPressed: () {
                            state.retry?.call();
                          },
                          child: Text('Retry'))
                    ],
                  )
                : Text(state.message),
          );
        } else {
          return Expanded(
            child: Container(),
          );
        }
      },
    );
  }

  Widget _buildTvSeriesSearch() {
    return BlocBuilder<TvSeriesSearchBloc, TvSeriesSearchState>(
      builder: (context, state) {
        if (state is TvSeriesSearchLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TvSeriesSearchHasData) {
          final result = state.data;
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final tv = result[index];
                return IdPosterTitleOverviewCard(tv);
              },
              itemCount: result.length,
            ),
          );
        } else if (state is TvSeriesSearchEmpty) {
          return Center(
            child: Text(state.message),
          );
        } else if (state is TvSeriesSearchError) {
          return Center(
            child: Column(
              children: [
                Text(state.message),
                ElevatedButton(
                    onPressed: () {
                      state.retry();
                    },
                    child: Text('Retry'))
              ],
            ),
          );
        } else {
          return Expanded(
            child: Container(),
          );
        }
      },
    );
  }
}

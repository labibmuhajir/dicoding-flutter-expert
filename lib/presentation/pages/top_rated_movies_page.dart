import 'package:ditonton/presentation/bloc/top_rated_movie/top_rated_movie_bloc.dart';
import 'package:ditonton/presentation/widgets/ditonton_error_widget.dart';
import 'package:ditonton/presentation/widgets/id_poster_title_overview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedMoviesPage extends StatelessWidget {
  static const ROUTE_NAME = '/top-rated-movie';

  @override
  Widget build(BuildContext context) {
    context.read<TopRatedMovieBloc>().add(OnTopRatedMovieDataRequested());

    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedMovieBloc, TopRatedMovieState>(
          builder: (context, state) {
            if (state is TopRatedMovieLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedMovieSuccess) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  return IdPosterTitleOverviewCard(movie);
                },
                itemCount: state.movies.length,
              );
            } else if (state is TopRatedMovieError) {
              return DitontonErrorWidget(
                state.message, retry: state.retry,
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}


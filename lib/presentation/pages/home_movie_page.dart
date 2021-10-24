import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv_series_list_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_list.dart';
import 'package:ditonton/presentation/widgets/row_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HomeMoviePage extends StatefulWidget {
  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

enum HomeState { TvSeries, Movies }

class _HomeMoviePageState extends State<HomeMoviePage> {
  HomeState state = HomeState.Movies;

  @override
  void initState() {
    super.initState();
    //  if (state == HomeState.TvSeries) {
    Future.microtask(
        () => Provider.of<TvSeriesListNotifier>(context, listen: false)
          ..fetchOnTheAirTvSeries()
          ..fetchPopularTvSeries()
          ..fetchTopRatedTvSeries());
    //} else {
    Future.microtask(
        () => Provider.of<MovieListNotifier>(context, listen: false)
          ..fetchNowPlayingMovies()
          ..fetchPopularMovies()
          ..fetchTopRatedMovies());
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  state = HomeState.Movies;
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Tv Series'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  state = HomeState.TvSeries;
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton ${state == HomeState.Movies ? 'Movie' : 'Tv'}'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.ROUTE_NAME,
                  arguments: state);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              state == HomeState.TvSeries ? _buildTvSeries() : _buildMovies()),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }

  SingleChildScrollView _buildMovies() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Now Playing',
            style: kHeading6,
          ),
          Consumer<MovieListNotifier>(builder: (context, data, child) {
            final state = data.nowPlayingState;
            if (state == RequestState.Loading) {
              return RowLoading();
            } else if (state == RequestState.Loaded) {
              return MovieList.fromMovies(data.nowPlayingMovies);
            } else {
              return Text('Failed');
            }
          }),
          _buildSubHeading(
            title: 'Popular',
            onTap: () =>
                Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
          ),
          Consumer<MovieListNotifier>(builder: (context, data, child) {
            final state = data.popularMoviesState;
            if (state == RequestState.Loading) {
              return RowLoading();
            } else if (state == RequestState.Loaded) {
              return MovieList.fromMovies(data.popularMovies);
            } else {
              return Text('Failed');
            }
          }),
          _buildSubHeading(
            title: 'Top Rated',
            onTap: () =>
                Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
          ),
          Consumer<MovieListNotifier>(builder: (context, data, child) {
            final state = data.topRatedMoviesState;
            if (state == RequestState.Loading) {
              return RowLoading();
            } else if (state == RequestState.Loaded) {
              return MovieList.fromMovies(data.topRatedMovies);
            } else {
              return Text('Failed');
            }
          }),
        ],
      ),
    );
  }

  SingleChildScrollView _buildTvSeries() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'On The Air Tv Series',
            style: kHeading6,
          ),
          Consumer<TvSeriesListNotifier>(builder: (context, data, child) {
            final state = data.onTheAirState;
            if (state == RequestState.Loading) {
              return RowLoading();
            } else if (state == RequestState.Loaded) {
              return MovieList(data.onTheAirTvSeries);
            } else {
              return Text('Failed');
            }
          }),
          _buildSubHeading(
            title: 'Popular Tv Series',
            onTap: () =>
                Navigator.pushNamed(context, PopularTvSeriesPage.ROUTE_NAME),
          ),
          Consumer<TvSeriesListNotifier>(builder: (context, data, child) {
            final state = data.popularState;
            if (state == RequestState.Loading) {
              return RowLoading();
            } else if (state == RequestState.Loaded) {
              return MovieList(data.popularTvSeries);
            } else {
              return Text('Failed');
            }
          }),
          _buildSubHeading(
            title: 'Top Rated',
            onTap: () =>
                Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
          ),
          Consumer<TvSeriesListNotifier>(builder: (context, data, child) {
            final state = data.topRatedState;
            if (state == RequestState.Loading) {
              return RowLoading();
            } else if (state == RequestState.Loaded) {
              return MovieList(data.topRatedTvSeries);
            } else {
              return Text('Failed');
            }
          }),
        ],
      ),
    );
  }
}

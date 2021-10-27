import 'package:ditonton/domain/entities/id_and_data_type.dart';
import 'package:ditonton/domain/entities/id_poster_data_type.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/widgets/ditonton_image.dart';
import 'package:flutter/material.dart';

class MovieList extends StatelessWidget {
  final List<IdPosterDataType> idAndPoster;

  MovieList(this.idAndPoster);

  factory MovieList.fromMovies(List<Movie> movies) {
    final idAndPoster =
        movies.map((e) => IdPosterDataType.fromMovie(e)).toList();
    return MovieList(idAndPoster);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final idPoster = idAndPoster[index];
          return Container(
            width: 140,
            padding: const EdgeInsets.all(8),
            child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    MovieDetailPage.ROUTE_NAME,
                    arguments: IdAndDataType.fromIdPosterDataType(idPoster),
                  );
                },
                child: DitontonImage(idPoster.poster)),
          );
        },
        itemCount: idAndPoster.length,
      ),
    );
  }
}

import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final tPopularTvSeries = TvSeriesModel(
    firstAirDate: '2021-09-17',
    genreIds: [10759, 9648, 18],
    id: 93405,
    name: "Squid Game",
    originCountry: ["KR"],
    originalLanguage: "ko",
    originalName: "오징어 게임",
    overview:
        "Hundreds of cash-strapped players accept a strange invitation to compete in children's games—with high stakes. But, a tempting prize awaits the victor.",
    popularity: 7594.094,
    posterPath: "/dDlEmu3EZ0Pgg93K2SVNLCjCSvE.jpg",
    voteAverage: 7.9,
    voteCount: 7242);

final tPopularTvSeriesList = [tPopularTvSeries];

final tOnTheAirTvSeries = TvSeriesModel(
    firstAirDate: '2020-09-14',
    genreIds: [],
    id: 107602,
    name: '5 chefs dans ma cuisine',
    originCountry: ['CA'],
    originalLanguage: 'fr',
    originalName: '5 chefs dans ma cuisine',
    overview: 'overview is empty',
    popularity: 931.168,
    posterPath: '/2UuRWSoLCTohtKOTpKI1lwL5GrD.jpg',
    voteAverage: 1.7,
    voteCount: 3);

final tOnTheAirTvSeriesList = [tOnTheAirTvSeries];

final tTopRatedTvSeries = TvSeriesModel(
    firstAirDate: '2021-09-03',
    genreIds: [99],
    id: 106600,
    name: 'BTS In the SOOP',
    originCountry: ['KR'],
    originalLanguage: 'In the SOOP BTS편',
    originalName: 'In the SOOP BTS편',
    overview:
        'In the SOOP BTS ver. is a reality show, portraying BTS members everyday life, relaxation, and everything in between, away from the city life. A time of freedom and healing in a place for BTS, and BTS only.',
    popularity: 59.122,
    voteAverage: 9.3,
    voteCount: 1079,
    posterPath: '/hqFaSNICeh0Y3Hp0gtEIzDBmUVo.jpg');

final tTopRatedSeriesList = [tTopRatedTvSeries];

final tSearchTvSeries = TvSeriesModel(
    firstAirDate: "2001-01-14",
    genreIds: [35],
    id: 2331,
    name: 'Phoenix Nights',
    originCountry: ['GB'],
    originalLanguage: 'en',
    originalName: 'Phoenix Nights',
    overview:
        'The owner of The Phoenix Club is the wheelchair-bound Brian Potter, who has presided over two clubs in the past: the first (The Aquarius) flooded, the second (The Neptune) burned down. His ambition (with the help of Jerry St Clair) is to see The Phoenix Club become the most popular in Bolton and thus outdo his arch-nemesis, Den Perry, owner of rival club The Banana Grove.',
    popularity: 4.627,
    voteAverage: 8,
    voteCount: 27);

final tSearchTvSeriesList = [tSearchTvSeries];

final tTvDetail = TvDetailModel(
    id: 2331,
    name: "Phoenix Nights",
    genres: [GenreModel(id: 35, name: "Comedy")],
    posterPath: "/jZcUdxCsd53o3Npp53wD9hfOZCh.jpg",
    voteAverage: 8,
    overview:
        "The Phoenix has risen and the punters are back. Brian isn't surprised when the brewery decides to come and celebrate his victory and throws a gala Stars in Their Eyes show.",
    numberOfEpisodes: 12,
    numberOfSeasons: 2);

final tTvRecommendation = TvSeriesModel(
    firstAirDate: "1981-09-08",
    genreIds: [35],
    id: 72,
    name: "Only Fools and Horses",
    originCountry: ["GB"],
    originalLanguage: "en",
    originalName: "Only Fools and Horses",
    overview:
        "The misadventures of two wheeler dealer brothers Del Boy and Rodney Trotter of “Trotters Independent Traders PLC” who scrape their living by selling dodgy goods believing that next year they will be millionaires.",
    popularity: 13.616,
    voteAverage: 7.9,
    voteCount: 179);

final tTvRecommendationList = [tTvRecommendation];

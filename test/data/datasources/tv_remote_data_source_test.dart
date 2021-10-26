import 'dart:io';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  late TvRemoteDataSource dataSource;
  late MockHttpClient client;

  setUp(() {
    client = MockHttpClient();
    dataSource = TvRemoteDataSourceImpl(client: client);
  });

  void arrangeApiCall(Uri uri, String response, int statusCode) {
    when(client.get(uri))
        .thenAnswer((_) async => http.Response(response, statusCode, headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
            }));
  }

  group('get popular tv', () {
    final dummyTvPopular = 'dummy_data/tv_popular.json';
    final decoded = json.decode(readJson(dummyTvPopular));
    final tSearialTvList = TvSeriesResponse.fromJson(decoded).serialTvList;

    // void arrangeApiCall(Uri uri, String response, int statusCode) {
    //   when(client.get(uri)).thenAnswer(
    //       (_) async => http.Response(response, statusCode, headers: {
    //             HttpHeaders.contentTypeHeader:
    //                 'application/json; charset=utf-8',
    //           }));
    // }

    test("should return List of Tv when the response code is 200", () async {
      //arrange
      final mockPath = dummyTvPopular;
      final matcher = tSearialTvList;

      final url = TvRemoteDataSourceImpl.urlPopularTvSeries;
      final uri = Uri.parse(url);
      final response = readJson(mockPath);
      final statusCode = 200;

      arrangeApiCall(uri, response, statusCode);

      //act
      final actual = await dataSource.getPopularTvSeries();

      //assert
      expect(actual, matcher);
    });

    test("should throw ServerException when the response code is not 200",
        () async {
      //arrange
      final mockPath = dummyTvPopular;
      final matcher = throwsA(isA<ServerException>());

      final url = TvRemoteDataSourceImpl.urlPopularTvSeries;
      final uri = Uri.parse(url);
      final response = readJson(mockPath);

      arrangeApiCall(uri, response, 500);

      //act
      final actual500 = () => dataSource.getPopularTvSeries();

      //assert
      expect(actual500, matcher);

      //arrange
      arrangeApiCall(uri, response, 404);

      //act
      final actual404 = () => dataSource.getPopularTvSeries();

      //assert
      expect(actual404, matcher);
    });
  });

  group('get top rated tv series', () {
    final dummyTvTopRated = 'dummy_data/tv_top_rated.json';
    final decoded = json.decode(readJson(dummyTvTopRated));
    final tSerialTvList = TvSeriesResponse.fromJson(decoded).serialTvList;

    // void arrangeApiCall(Uri uri, String response, int statusCode) {
    //   when(client.get(uri)).thenAnswer(
    //       (_) async => http.Response(response, statusCode, headers: {
    //             HttpHeaders.contentTypeHeader:
    //                 'application/json; charset=utf-8',
    //           }));
    // }

    test("should return Top Rated Tv Series when the response code is 200",
        () async {
      //arrange
      final mockPath = dummyTvTopRated;
      final matcher = tSerialTvList;

      final url = TvRemoteDataSourceImpl.urlTopRatedTvSeries;
      final uri = Uri.parse(url);
      final response = readJson(mockPath);
      final statusCode = 200;

      arrangeApiCall(uri, response, statusCode);

      //act
      final actual = await dataSource.getTopRatedTvSeries();

      //assert
      expect(actual, matcher);
    });

    test("should throw ServerException when the response code is not 200",
        () async {
      //arrange
      final mockPath = dummyTvTopRated;
      final matcher = throwsA(isA<ServerException>());

      final url = TvRemoteDataSourceImpl.urlTopRatedTvSeries;
      final uri = Uri.parse(url);
      final response = readJson(mockPath);

      arrangeApiCall(uri, response, 500);

      //act
      final actual = () => dataSource.getTopRatedTvSeries();

      //assert
      expect(actual, matcher);

      //arrange
      arrangeApiCall(uri, response, 404);

      final actual404 = () => dataSource.getTopRatedTvSeries();

      expect(actual404, matcher);
    });
  });

  group('get on the air tv series', () {
    final dummyTvOnTheAir = 'dummy_data/tv_on_the_air.json';
    final decoded = json.decode(readJson(dummyTvOnTheAir));
    final tSearialTvList = TvSeriesResponse.fromJson(decoded).serialTvList;

    // void arrangeApiCall(Uri uri, String response, int statusCode) {
    //   when(client.get(uri)).thenAnswer(
    //       (_) async => http.Response(response, statusCode, headers: {
    //             HttpHeaders.contentTypeHeader:
    //                 'application/json; charset=utf-8',
    //           }));
    // }

    test("should return List of Tv when the response code is 200", () async {
      //arrange
      final mockPath = dummyTvOnTheAir;
      final matcher = tSearialTvList;

      final url = TvRemoteDataSourceImpl.urlOnTheAirTvSeries;
      final uri = Uri.parse(url);
      final response = readJson(mockPath);
      final statusCode = 200;

      arrangeApiCall(uri, response, statusCode);

      //act
      final actual = await dataSource.getOnTheAirTvSeries();

      //assert
      expect(actual, matcher);
    });

    test("should throw ServerException when the response code is not 200",
        () async {
      //arrange
      final mockPath = dummyTvOnTheAir;
      final matcher = throwsA(isA<ServerException>());

      final url = TvRemoteDataSourceImpl.urlOnTheAirTvSeries;
      final uri = Uri.parse(url);
      final response = readJson(mockPath);

      arrangeApiCall(uri, response, 500);

      //act
      final actual = () => dataSource.getOnTheAirTvSeries();

      //assert
      expect(actual, matcher);

      //arrange
      arrangeApiCall(uri, response, 404);

      final actual404 = () => dataSource.getOnTheAirTvSeries();

      expect(actual404, matcher);
    });
  });

  group('search tv series', () {
    final dummySearchTvSeries = 'dummy_data/search_phoenix_tv_series.json';
    final decoded = json.decode(readJson(dummySearchTvSeries));

    final tSerialTvList = TvSeriesResponse.fromJson(decoded).serialTvList;
    final tQuery = 'phoenix';

    final url = TvRemoteDataSourceImpl.generateUrlTvSeries(tQuery);
    final uri = Uri.parse(url);

    // void arrangeApiCall(Uri uri, String response, int statusCode) {
    //   when(client.get(uri)).thenAnswer(
    //       (_) async => http.Response(response, statusCode, headers: {
    //             HttpHeaders.contentTypeHeader:
    //                 'application/json; charset=utf-8',
    //           }));
    // }

    test('should return list of movies when response code is 200', () async {
      final mockPath = dummySearchTvSeries;
      final matcher = tSerialTvList;

      final response = readJson(mockPath);
      final statusCode = 200;
      // arrange

      arrangeApiCall(uri, response, statusCode);

      // act
      final result = await dataSource.searchTvSeries(tQuery);
      // assert
      expect(result, matcher);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      final response = 'Not found';
      final statusCode = 404;

      arrangeApiCall(uri, response, statusCode);
      // act
      final call = dataSource.searchTvSeries(tQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv detail', () {
    final tId = 2331;
    final response = readJson('dummy_data/tv_detail.json');
    final tTvDetail = TvDetailModel.fromJson(json.decode(response));

    final url = TvRemoteDataSourceImpl.generateUrlTvDetail(tId);
    final uri = Uri.parse(url);

    test('should return tv detail when the response code is 200', () async {
      // arrange
      final statusCode = 200;

      arrangeApiCall(uri, response, statusCode);
      // act
      final result = await dataSource.getTvSeries(tId);
      // assert
      expect(result, equals(tTvDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      final statusCode = 404;

      arrangeApiCall(uri, response, statusCode);
      // act
      final call = dataSource.getTvSeries(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv series recommendations', () {
    final tId = 2331;
    final data = readJson('dummy_data/tv_recommendations.json');
    final tTvRecommendation =
        TvSeriesResponse.fromJson(json.decode(data)).serialTvList;

    final url = TvRemoteDataSourceImpl.generateUrlTvRecommendation(tId);
    final uri = Uri.parse(url);

    test('should return list of Movie Model when the response code is 200',
        () async {
      // arrange
      final response = data;
      final statusCode = 200;
      arrangeApiCall(uri, response, statusCode);
      // act
      final result = await dataSource.getTvSeriesRecommendation(tId);
      // assert
      expect(result, equals(tTvRecommendation));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      final response = 'Not Found';
      final statusCode = 404;
      arrangeApiCall(uri, response, statusCode);

      // act
      final call = dataSource.getTvSeriesRecommendation(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}

import 'dart:convert';

import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:http/http.dart' as http;

abstract class TvRemoteDataSource {
  Future<List<TvSeriesModel>> getPopularTvSeries();
  Future<List<TvSeriesModel>> getOnTheAirTvSeries();
  Future<List<TvSeriesModel>> getTopRatedTvSeries();
  Future<List<TvSeriesModel>> searchTvSeries(String keyword);
  Future<TvDetailModel> getTvSeries(int id);
  Future<List<TvSeriesModel>> getTvSeriesRecommendation(int id);
}

class TvRemoteDataSourceImpl implements TvRemoteDataSource {
  static final urlPopularTvSeries = '$BASE_URL/tv/popular?$API_KEY';
  static final urlOnTheAirTvSeries = '$BASE_URL/tv/on_the_air?$API_KEY';
  static final urlTopRatedTvSeries = '$BASE_URL/tv/top_rated?$API_KEY';
  static String generateUrlTvSeries(String query) =>
      '$BASE_URL/search/tv?$API_KEY&query=$query';
  static String generateUrlTvDetail(int id) => '$BASE_URL/tv/$id?$API_KEY';
  static String generateUrlTvRecommendation(int id) =>
      '$BASE_URL/tv/$id/recommendations?$API_KEY';

  final http.Client client;

  TvRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvSeriesModel>> getOnTheAirTvSeries() async {
    final uri = Uri.parse(urlOnTheAirTvSeries);
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      return TvSeriesResponse.fromJson(decoded).serialTvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> getPopularTvSeries() async {
    final uri = Uri.parse(urlPopularTvSeries);
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      return TvSeriesResponse.fromJson(decoded).serialTvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> getTopRatedTvSeries() async {
    final uri = Uri.parse(urlTopRatedTvSeries);
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      return TvSeriesResponse.fromJson(decoded).serialTvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> searchTvSeries(String keyword) async {
    final url = generateUrlTvSeries(keyword);
    final uri = Uri.parse(url);
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return TvSeriesResponse.fromJson(decoded).serialTvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvDetailModel> getTvSeries(int id) async {
    final url = generateUrlTvDetail(id);
    final uri = Uri.parse(url);
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return TvDetailModel.fromJson(decoded);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> getTvSeriesRecommendation(int id) async {
    final url = generateUrlTvRecommendation(id);
    final uri = Uri.parse(url);
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return TvSeriesResponse.fromJson(decoded).serialTvList;
    } else {
      throw ServerException();
    }
  }
}

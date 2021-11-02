// Mocks generated by Mockito 5.0.8 from annotations
// in ditonton/test/presentation/pages/movie_detail_page_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i11;
import 'dart:ui' as _i12;

import 'package:ditonton/common/state_enum.dart' as _i10;
import 'package:ditonton/domain/entities/content_data.dart' as _i4;
import 'package:ditonton/domain/entities/id_poster_data_type.dart' as _i9;
import 'package:ditonton/domain/entities/movie.dart' as _i14;
import 'package:ditonton/domain/entities/movie_detail.dart' as _i7;
import 'package:ditonton/domain/usecases/get_movie_detail.dart' as _i5;
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart' as _i6;
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart' as _i2;
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart'
    as _i3;
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart'
    as _i13;
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart' as _i8;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeGetTvSeriesDetail extends _i1.Fake implements _i2.GetTvSeriesDetail {
}

class _FakeGetTvSeriesRecommendations extends _i1.Fake
    implements _i3.GetTvSeriesRecommendations {}

class _FakeContentData extends _i1.Fake implements _i4.ContentData {}

class _FakeGetMovieDetail extends _i1.Fake implements _i5.GetMovieDetail {}

class _FakeGetMovieRecommendations extends _i1.Fake
    implements _i6.GetMovieRecommendations {}

class _FakeMovieDetail extends _i1.Fake implements _i7.MovieDetail {}

/// A class which mocks [TvDetailNotifier].
///
/// See the documentation for Mockito's code generation for more information.
class MockTvDetailNotifier extends _i1.Mock implements _i8.TvDetailNotifier {
  MockTvDetailNotifier() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.GetTvSeriesDetail get getTvSeriesDetail =>
      (super.noSuchMethod(Invocation.getter(#getTvSeriesDetail),
          returnValue: _FakeGetTvSeriesDetail()) as _i2.GetTvSeriesDetail);
  @override
  _i3.GetTvSeriesRecommendations get getTvSeriesRecommendations =>
      (super.noSuchMethod(Invocation.getter(#getTvSeriesRecommendations),
              returnValue: _FakeGetTvSeriesRecommendations())
          as _i3.GetTvSeriesRecommendations);
  @override
  _i4.ContentData get tvSeries =>
      (super.noSuchMethod(Invocation.getter(#tvSeries),
          returnValue: _FakeContentData()) as _i4.ContentData);
  @override
  List<_i9.IdPosterDataType> get recommendations =>
      (super.noSuchMethod(Invocation.getter(#recommendations),
          returnValue: <_i9.IdPosterDataType>[]) as List<_i9.IdPosterDataType>);
  @override
  _i10.RequestState get tvSeriesState =>
      (super.noSuchMethod(Invocation.getter(#tvSeriesState),
          returnValue: _i10.RequestState.Empty) as _i10.RequestState);
  @override
  _i10.RequestState get recommendationState =>
      (super.noSuchMethod(Invocation.getter(#recommendationState),
          returnValue: _i10.RequestState.Empty) as _i10.RequestState);
  @override
  String get message =>
      (super.noSuchMethod(Invocation.getter(#message), returnValue: '')
          as String);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  _i11.Future<void> fetchTvDetail(int? id) =>
      (super.noSuchMethod(Invocation.method(#fetchTvDetail, [id]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future.value()) as _i11.Future<void>);
  @override
  void addListener(_i12.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(_i12.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}

/// A class which mocks [MovieDetailNotifier].
///
/// See the documentation for Mockito's code generation for more information.
class MockMovieDetailNotifier extends _i1.Mock
    implements _i13.MovieDetailNotifier {
  MockMovieDetailNotifier() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.GetMovieDetail get getMovieDetail =>
      (super.noSuchMethod(Invocation.getter(#getMovieDetail),
          returnValue: _FakeGetMovieDetail()) as _i5.GetMovieDetail);
  @override
  _i6.GetMovieRecommendations get getMovieRecommendations =>
      (super.noSuchMethod(Invocation.getter(#getMovieRecommendations),
              returnValue: _FakeGetMovieRecommendations())
          as _i6.GetMovieRecommendations);
  @override
  _i7.MovieDetail get movie => (super.noSuchMethod(Invocation.getter(#movie),
      returnValue: _FakeMovieDetail()) as _i7.MovieDetail);
  @override
  _i10.RequestState get movieState =>
      (super.noSuchMethod(Invocation.getter(#movieState),
          returnValue: _i10.RequestState.Empty) as _i10.RequestState);
  @override
  List<_i14.Movie> get movieRecommendations =>
      (super.noSuchMethod(Invocation.getter(#movieRecommendations),
          returnValue: <_i14.Movie>[]) as List<_i14.Movie>);
  @override
  _i10.RequestState get recommendationState =>
      (super.noSuchMethod(Invocation.getter(#recommendationState),
          returnValue: _i10.RequestState.Empty) as _i10.RequestState);
  @override
  String get message =>
      (super.noSuchMethod(Invocation.getter(#message), returnValue: '')
          as String);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  _i11.Future<void> fetchMovieDetail(int? id) =>
      (super.noSuchMethod(Invocation.method(#fetchMovieDetail, [id]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future.value()) as _i11.Future<void>);
  @override
  void addListener(_i12.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(_i12.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}

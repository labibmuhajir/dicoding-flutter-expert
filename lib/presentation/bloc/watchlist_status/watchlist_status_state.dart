part of 'watchlist_status_bloc.dart';

abstract class WatchlistStatusState extends Equatable {
  const WatchlistStatusState();

  @override
  List<Object> get props => [];
}

class WatchlistStatusInitial extends WatchlistStatusState {}

class WatchlistStatusLoading extends WatchlistStatusState {}

class WatchlistStatusLoaded extends WatchlistStatusState {
  final bool isAdded;

  WatchlistStatusLoaded(this.isAdded);

  @override
  List<Object> get props => [isAdded];
}

class WatchlistStatusError extends WatchlistStatusState {
  final String message;
  final Function retry;

  WatchlistStatusError(this.message, {required this.retry});

  @override
  List<Object> get props => [message];
}

class WatchlistStatusSuccess extends WatchlistStatusState {
  final String message;

  WatchlistStatusSuccess(this.message);

  @override
  List<Object> get props => [message];
}

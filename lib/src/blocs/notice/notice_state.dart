import 'package:equatable/equatable.dart';

import 'package:ioesolutions/src/models/notice_model.dart';

abstract class NoticeState extends Equatable {
  const NoticeState();

  @override
  List<Object> get props => [];
}

class NoticeInitial extends NoticeState {}

class NoticeFailure extends NoticeState {
  final String error;
  const NoticeFailure({this.error});
  @override
  List<Object> get props => [error];
}

class NoticesLoaded extends NoticeState {
  final List<Notice> notices;
  final bool hasReachedMax;

  const NoticesLoaded({
    this.notices,
    this.hasReachedMax,
  });

  NoticesLoaded copyWith({
    List<Notice> notices,
    bool hasReachedMax,
  }) {
    return NoticesLoaded(
      notices: notices ?? this.notices,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [notices, hasReachedMax];

  @override
  String toString() =>
      'NoticesLoaded { notices: ${notices.length}, hasReachedMax: $hasReachedMax }';
}

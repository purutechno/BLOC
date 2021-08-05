import 'package:equatable/equatable.dart';

abstract class NoticeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchNotices extends NoticeEvent {}

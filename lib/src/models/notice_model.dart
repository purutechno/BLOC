import 'package:equatable/equatable.dart';

class Notice extends Equatable {
  final int id;
  final String title;
  final String noticeDate;
  final String link;

  const Notice({this.id, this.title, this.link,this.noticeDate});

  @override
  List<Object> get props => [id, title, link,noticeDate];

  @override
  String toString() => 'Notice { id: $id }';
}

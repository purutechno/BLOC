import 'package:equatable/equatable.dart';

class News extends Equatable {
  int id;
  String title;
  String image_name;
  String thumbnail_link;
  String news_date;
   News({this.id,this.title,this.image_name,this.news_date,this.thumbnail_link});

  @override
  List<Object> get props => [id, title, image_name,thumbnail_link];

  @override
  String toString() => 'News { id: $id }';
}

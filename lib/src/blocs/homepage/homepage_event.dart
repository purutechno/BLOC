import 'package:equatable/equatable.dart';

abstract class HomepageEvent extends Equatable {
  const HomepageEvent();

  @override
  List<Object> get props => [];
}
class LoadHomepageData extends HomepageEvent {}

class CheckIfDataAvailable extends HomepageEvent {}


import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class HomepageState extends Equatable {
  const HomepageState();

  @override
  List<Object> get props => [];
}
class HomepageInitial extends HomepageState {}

class HomepageDataLoading extends HomepageState {}

class HomepageDataLoaded extends HomepageState {
  final homepageData;
  const HomepageDataLoaded({@required this.homepageData});
  
  @override
  List<Object> get props => [homepageData];

  @override
  String toString() => 'HomepageDataLoaded { HomePageData: $homepageData }';
}

class HomepageFailure extends HomepageState {
    final error;

  const HomepageFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'HomepageFailure { error: $error }';
}
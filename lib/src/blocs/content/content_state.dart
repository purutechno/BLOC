import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ContentState extends Equatable {
  const ContentState();

  @override
  List<Object> get props => [];
}
class ContentPageInitial extends ContentState {}

// class SubjectsLoading extends ContentState {}
class ContentLoading extends ContentState {}

class OldQuestionPageReady extends ContentState {}

class ContentPageNoResponse extends ContentState {}

class UpdatingContents extends ContentState {}
class LoadingNewContents extends ContentState {}
class ContentSaved extends ContentState {}

class ContentLoaded extends ContentState {
  final content;
  const ContentLoaded({@required this.content});
  
  @override
  List<Object> get props => [content];

  @override
  String toString() => 'ContentLoaded { content: $content }';
}

class ContentLoadFailure extends ContentState {
    final error;

  const ContentLoadFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ContentLoadFailure { error: $error }';
}
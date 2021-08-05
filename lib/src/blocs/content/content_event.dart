import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class ContentEvent extends Equatable {
  const ContentEvent();
  @override
  List<Object> get props => null;
}

class CheckIfContentsExist extends ContentEvent{}

class LoadExtraContents extends ContentEvent{}

class CheckForContentUpdate extends ContentEvent {
  final  app_config;

  const CheckForContentUpdate({
    @required this.app_config
  });
  

  @override
  List<Object> get props => [app_config];

  @override
  String toString() =>
      'CheckForContentUpdate { app_config: $app_config}';
}

class FetchAllContents extends ContentEvent {}

class MakeOldQuestionPageReady extends ContentEvent {}

class UpdateAllContents extends ContentEvent {}

class ViewContent extends ContentEvent {
  final String subject_id;

  const ViewContent({
    @required this.subject_id,
  });
  

  @override
  List<Object> get props => [subject_id];

  @override
  String toString() =>
      'ViewContent { subject_id: $subject_id}';
}

class LoadSubjects extends ContentEvent {
  final String content_type;
  final String faculty;
  final String semester;

  const LoadSubjects({
    @required this.content_type,
    @required this.faculty,
    @required this.semester
  });
  

  @override
  List<Object> get props => [content_type, faculty,semester];

  @override
  String toString() =>
      'LoadSubjects { content_type: $content_type, faculty: $faculty,semester: $semester }';
}

class LoadSyllabusContent extends ContentEvent {
  final String subject_id;

  const LoadSyllabusContent({
    @required this.subject_id,
  });
  

  @override
  List<Object> get props => [subject_id];

  @override
  String toString() =>
      'LoadSyllabusContent {subject_id: $subject_id}';
}


class LoadNoteTypesForSubject extends ContentEvent {
  final String subject_id;

  const LoadNoteTypesForSubject({
    @required this.subject_id,
  });
  

  @override
  List<Object> get props => [subject_id];

  @override
  String toString() =>
      'LoadNoteTypesForSubject {subject_id: $subject_id}';
}

class LoadOldQuestionsFiles extends ContentEvent {
  final String subject_id;

  const LoadOldQuestionsFiles({
    @required this.subject_id,
  });
  

  @override
  List<Object> get props => [subject_id];

  @override
  String toString() =>
      'LoadOldQuestionsFiles {subject_id: $subject_id}';
}









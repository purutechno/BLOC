import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class DownloadEvent extends Equatable {
  const DownloadEvent();
  @override
  List<Object> get props => null;
}

class LoadPdfOnline extends DownloadEvent {
  final String file_id;

  const LoadPdfOnline({
    @required this.file_id
  });
  

  @override
  List<Object> get props => [file_id];

  @override
  String toString() =>
      'LoadPdfOnline { file_id: $file_id}';
}

class LoadSubjectContent extends DownloadEvent {
  final String subject_id;

  const LoadSubjectContent({
    @required this.subject_id,
  });
  

  @override
  List<Object> get props => [subject_id];

  @override
  String toString() =>
      'LoadSubjectContent {subject_id: $subject_id}';
}










import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class DownloadState extends Equatable {
  const DownloadState();

  @override
  List<Object> get props => [];
}

class DownloadPageInitial extends DownloadState {}

class PdfLoading extends DownloadState {}

class PdfLoaded extends DownloadState {
  final String file_path;

  const PdfLoaded({
    @required this.file_path,
  });
  

  @override
  List<Object> get props => [file_path];

  @override
  String toString() =>
      'PdfLoaded { file_path: $file_path}';
}

class PdfLoadFailure extends DownloadState {
    final error;

  const PdfLoadFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'PdfLoadFailure { error: $error }';
}
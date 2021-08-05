import 'package:equatable/equatable.dart';

abstract class MasterState extends Equatable {
  @override
  List<Object> get props => [];
}

class MasterInitial extends MasterState {}

class MasterLoading extends MasterState {}

class LoadingComplete extends MasterState {}

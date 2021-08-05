import 'package:equatable/equatable.dart';

abstract class MasterEvent extends Equatable {
  const MasterEvent();

  @override
  List<Object> get props => [];
}
class AppStarted extends MasterEvent {}
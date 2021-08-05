import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();
  @override
  List<Object> get props => null;
}
class CheckInternetConnection extends ConnectivityEvent{}

class ConnectionChanged extends ConnectivityEvent{}









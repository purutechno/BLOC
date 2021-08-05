import 'package:equatable/equatable.dart';
import 'package:ioesolutions/src/blocs/connectivity/connectivity_state.dart';
import 'package:meta/meta.dart';

 class ConnectivityState extends Equatable {
  @override
  
  List<Object> get props => null;
}
class ConnectivityInitial extends ConnectivityState {}

class ConnectionStateChanged extends ConnectivityState {
  final bool hasInternetConnection;
  ConnectionStateChanged(this.hasInternetConnection);
  @override
  List<Object> get props => [hasInternetConnection];

}

class HasInternetConnection extends ConnectivityState {}

class NoInternetConnection extends ConnectivityState {}



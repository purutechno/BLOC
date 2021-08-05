import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:ioesolutions/src/admob/admob_manager.dart';
import 'package:ioesolutions/src/app.dart';
import 'package:ioesolutions/src/blocs/connectivity/connectivity_bloc.dart';
import 'package:ioesolutions/src/blocs/connectivity/connectivity_event.dart';
import 'package:ioesolutions/src/blocs/master/master_bloc.dart';
import 'package:ioesolutions/src/blocs/master/master_event.dart';
const debug = true;
void main() async{

  final Connectivity _connectivity = Connectivity();
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: debug);
  AdmobManager.initAdMob();
  runApp(
    MultiBlocProvider(
    providers: [
      BlocProvider<MasterBloc>(
      create: (BuildContext context)=> MasterBloc()..add(AppStarted())
      ),
      BlocProvider<ConnectivityBloc>(
      create: (BuildContext context)=> ConnectivityBloc(_connectivity)..add(CheckInternetConnection())
      ),
  ],
   child: MyApp(),
),
  );
}



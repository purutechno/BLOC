import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ioesolutions/src/screens/about.dart';
import 'package:ioesolutions/src/screens/splash_screen.dart';
import 'package:ioesolutions/src/screens/mainscreen.dart';
import 'package:ioesolutions/src/screens/notes.dart';
import 'package:ioesolutions/src/screens/semesters.dart';
import 'package:ioesolutions/src/screens/syllabus_subjects.dart';
import 'package:ioesolutions/src/screens/faculties.dart';
import 'package:ioesolutions/src/blocs/master/master_bloc.dart';
import 'package:ioesolutions/src/blocs/master/master_state.dart';
class MyApp extends StatelessWidget {

  const MyApp();
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      routes: {
        // '/' : (context) => Home(),
        '/main' : (context) => MainScreen(),
        // '/syllabus' : (context) => Syllabus(),
        '/semester' : (context) => Semester(),
        '/notes' : (context) => Notes(),
        // '/subjects' : (context) => Subjects(),
        '/about' : (context) => About(),
      },
      home: BlocBuilder<MasterBloc,MasterState>(
        builder: (context,state){
          if(state is MasterInitial)
          {
            return SplashScreen();
          }
          if(state is MasterLoading)
          {
            return SplashScreen();
          }
          if(state is LoadingComplete)
          {
            return MainScreen();
          }
        },
      )
      );
  }
}
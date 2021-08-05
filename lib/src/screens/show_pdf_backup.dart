import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ioesolutions/src/blocs/download/download_bloc.dart';
import 'package:ioesolutions/src/blocs/download/download_event.dart';
import 'package:ioesolutions/src/blocs/download/download_state.dart';
import 'package:ioesolutions/src/screens/components/loading_indicator.dart';

class ShowPdfBackup extends StatelessWidget {
  final String fileId;
  const ShowPdfBackup({this.fileId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff860000),
        title: Text("View Pdf file"),
      ),
      body: BlocProvider<DownloadBloc>(
            create: (_) => DownloadBloc()..add(LoadPdfOnline(file_id:fileId)),
            child: ShowPdfBackupBody(),
    ), 
    );
  }
}

class ShowPdfBackupBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder(
      bloc: BlocProvider.of<DownloadBloc>(context),
      builder: (context, state) {
        if(state is PdfLoading)
        {
          return loadingIndicator();
        }
        if(state is PdfLoaded)
        {
          return Container(child: Text("PDF file Loaded"),);
        }
        if(state is PdfLoadFailure)
        {
          return Center(
            child: Text("${state.error["message"]}"),
          );
        }
        return Container();
      }),
    );
  }
}
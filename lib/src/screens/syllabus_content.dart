import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ioesolutions/src/blocs/content/content_bloc.dart';
import 'package:ioesolutions/src/blocs/content/content_event.dart';
import 'package:ioesolutions/src/blocs/content/content_state.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:ioesolutions/src/screens/components/loading_indicator.dart';

class SyllabusContent extends StatelessWidget {
  final String subject_id;
  final String subject_name;
  final String subject_content;
  const SyllabusContent(
      {this.subject_id, this.subject_content, this.subject_name});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$subject_name",
          style: TextStyle(fontSize: 14),
        ),
        backgroundColor: Color(0xff860000),
      ),
      body: BlocProvider<ContentBloc>(
        create: (_) =>
            ContentBloc()..add(LoadSyllabusContent(subject_id: subject_id)),
        child: SyllabusContentBody(),
      ),
    );
  }
}

class SyllabusContentBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: BlocBuilder(
          bloc: BlocProvider.of<ContentBloc>(context),
          builder: (context, state) {
            if (state is ContentLoading) {
              return loadingIndicator();
            }
            if (state is ContentLoaded) {
              if (state.content.length == 0) {
                return Center(
                  child: Text(
                    "Syllabus for this subject will be available soon!",
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                );
              }
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top:20,bottom:20),
                  child: HtmlWidget(
                    state.content[0]["subject_content"],
                  ),
                ),
              );
            }
            if (state is ContentLoadFailure) {
              return Center(
                child: Text(state.error["message"]),
              );
            }
            return Container();
          }),
    );
  }
}

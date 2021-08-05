import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class TextNoteContent extends StatelessWidget {
  final String chapter_name;
  final  chapter_content;
  const TextNoteContent(
      {this.chapter_content, this.chapter_name});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$chapter_name",
          style: TextStyle(fontSize: 14),
        ),
        backgroundColor: Color(0xff860000),
      ),
      body: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top:20,bottom:20,left: 10,right: 10),
                  child: HtmlWidget(
                    chapter_content,
                  ),
                ),
              ),
    );
  }
}

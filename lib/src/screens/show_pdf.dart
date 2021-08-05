import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:ioesolutions/src/admob/admob_manager.dart';

class ShowPdf extends StatefulWidget {
  final String filename;
  final String pdf_path;
  const ShowPdf({this.filename,this.pdf_path});

  @override
  _ShowPdfState createState() => _ShowPdfState();
}

class _ShowPdfState extends State<ShowPdf> {
  @override
  void initState()
  {
    super.initState();
    _loadIntertistialAd();
    
  }
  _loadIntertistialAd()
  {
    Random random = new Random();
    int randomNumber = random.nextInt(4);
    print("Random number is $randomNumber");
    if(randomNumber %3 ==0)
    {
      AdmobManager.interstitialAd.load();
    }
    
  }
  @override 
  void dispose()
  {
    super.dispose();
    AdmobManager.interstitialAd.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
    if (await AdmobManager.interstitialAd.isLoaded) {
      AdmobManager.interstitialAd.show();
      }
      else{
        return Future.value(true);
      }
      
      },
      child: PDFViewerScaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff860000),
            title: Text("${widget.filename}",style: TextStyle(fontSize: 15),),
          ),
          path: widget.pdf_path),
    );
  }
}









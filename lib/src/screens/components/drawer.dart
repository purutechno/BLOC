import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ioesolutions/src/blocs/content/content_event.dart';
import 'package:ioesolutions/src/classes/drawer.dart';
import 'package:ioesolutions/src/screens/downloads.dart';
import 'package:ioesolutions/src/screens/about.dart';
import 'package:url_launcher/url_launcher.dart';
_launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
void _onTextShareButtonPressed() async {
  String title, status;
  title = "SHARE APP";
  status =
      "Get the IOE Solutions app from here.        https://play.google.com/store/apps/details?id=np.com.esign.ioesolutions ";
  Share.text(title, status, 'text/plain');
}
Widget generateDrawer(context,contentBloc) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        // Container(
        //   height: 150,
        //   color: Colors.indigo[900],
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: <Widget>[
        //       Text(
        //         "IOE Solutions",
        //         style: TextStyle(
        //             fontSize: 24.0,
        //             color: Colors.white,
        //             fontWeight: FontWeight.bold),
        //       ),
        //       SizedBox(
        //         height: 10,
        //       ),
        //       Text(
        //         "Version 1.0.0",
        //         style: TextStyle(color: Colors.white, fontSize: 12),
        //       )
        //     ],
        //   ),
        // ),
        Image.asset("images/ioesolutions_banner.png"),
        // update contents
        ListTile(
          onTap: (){
            Navigator.of(context).pop();
            contentBloc.add(UpdateAllContents());
          },
          leading: drawers[0].icon,
          title: Text(drawers[0].text),
          subtitle: Text(
            "This will update the offline contents",
            style: TextStyle(fontSize: 12),
          ),
        ),
        Divider(),
        // downloads 
        ListTile(
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => DownloadsPage())),
          leading: drawers[1].icon,
          title: Text(drawers[1].text),
        ),
        // send us a message
        ListTile(
          onTap: (){
                Navigator.of(context).pop();
                _launchUrl(
                    'mailto:solutions.ioe@gmail.com?subject=Please Enter a subject here&body=Select the message or files from device');
              },
          leading: drawers[2].icon,
          title: Text(drawers[2].text),
        ),
        // share app
        ListTile(
          onTap: (){
            Navigator.of(context).pop();
            _onTextShareButtonPressed();
          },
          leading: drawers[3].icon,
          title: Text(drawers[3].text),
        ),
        // rate us 
        ListTile(
          onTap: (){
            Navigator.of(context).pop();
            _launchUrl(
                "https://play.google.com/store/apps/details?id=np.com.esign.ioesolutions");
          },
          leading: drawers[4].icon,
          title: Text(drawers[4].text),
        ),
        // about
        ListTile(
          leading: drawers[5].icon,
          title: Text(drawers[5].text),
          onTap:()=>Navigator.of(context).push(MaterialPageRoute(
            builder: (context)=>About(),
          )),
        ),
        // privacy policy
        ListTile(
          leading: drawers[6].icon,
          title: Text(drawers[6].text),
        ),
        // find us on facebook
        ListTile(
          onTap: () {
            Navigator.of(context).pop();
            _launchUrl("https://www.facebook.com/ioesolutions");
          },
          leading: drawers[7].icon,
          title: Text(drawers[7].text),
        ),
      ],
    ),
  );
}

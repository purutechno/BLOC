import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ioesolutions/src/admob/admob_manager.dart';
import 'package:ioesolutions/src/app_config.dart';
import 'package:ioesolutions/src/blocs/connectivity/connectivity_bloc.dart';
import 'package:ioesolutions/src/blocs/connectivity/connectivity_state.dart';
import 'package:ioesolutions/src/blocs/content/content_bloc.dart';
import 'package:ioesolutions/src/blocs/content/content_event.dart';
import 'package:ioesolutions/src/blocs/content/content_state.dart';
import 'package:ioesolutions/src/blocs/homepage/homepage_bloc.dart';
import 'package:ioesolutions/src/blocs/homepage/homepage_event.dart';
import 'package:ioesolutions/src/blocs/homepage/homepage_state.dart';
import 'package:ioesolutions/src/presentation/my_flutter_app_icons.dart';
import 'package:ioesolutions/src/screens/components/loading_indicator.dart';
import 'package:ioesolutions/src/screens/faculties.dart';
import 'package:ioesolutions/src/screens/news_list.dart';
import 'package:ioesolutions/src/screens/notices_list.dart';
import 'package:ioesolutions/src/screens/pdf_loading_progress.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/drawer.dart';
import 'extra contents/show_folders.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomepageBloc>(
      create: (_) => HomepageBloc()..add(LoadHomepageData()),
      child: HomepageContents(),
    );
  }
}

class HomepageContents extends StatefulWidget {
  @override
  _HomepageContentsState createState() => _HomepageContentsState();
}

class _HomepageContentsState extends State<HomepageContents> {
  DateTime currentBackPressTime;

  bool checkedForUpdate = false;

  bool alertDialogDisplayed = false;
  bool closeAlertDialog = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final ContentBloc contentBloc = new ContentBloc();
  DateFormat newsDateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  var alertDialogContext;
  _showRecentNews(recent_news) {
    List<Widget> recentNews = [];
    for (var news in recent_news) {
      recentNews.add(
        Container(
          color: Colors.grey[200],
          child: ListTile(
            leading: CachedNetworkImage(
              height: 50,
              width: 50,
              fit: BoxFit.contain,
              placeholder: (context, url) => Image.asset('images/logo.png'),
              imageUrl:
                  "${app_config["image_base_url"]}/admin/image/article/small/${news["image"]}",
            ),
            title: Text(news['title'], style: TextStyle(fontSize: 12.0)),
            subtitle:
                Text(news['created_at'], style: TextStyle(fontSize: 12.0)),
          ),
        ),
      );
      recentNews.add(
        SizedBox(height: 5.0),
      );
    }
    return recentNews;
  }

  _showRecentNotices(recent_notices) {
    List<Widget> recentNotices = [];
    for (var notice in recent_notices) {
      recentNotices.add(
        Container(
          color: Colors.grey[200],
          child: ListTile(
            onTap: () async {
              var index = notice.link.indexOf(".pdf");
              if (index >= 0) {
                return Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LoadPdfPage(
                        filename: notice.title, link: notice.link)));
              } else {
                return await _launchUrl("${notice.link}");
              }
            },
            title: Text(notice['notice_title'].trim(),
                style: TextStyle(fontSize: 12.0)),
            subtitle:
                Text(notice['notice_date'], style: TextStyle(fontSize: 12.0)),
          ),
        ),
      );
      recentNotices.add(
        SizedBox(height: 5.0),
      );
    }
    return recentNotices;
  }

  _showDialog(context, String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        alertDialogContext = context;
        return AlertDialog(
          content: Row(
            children: <Widget>[
              Container(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                  "$message",
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _checkIfContentsExist() async {
    try {
      var databasesPath = await getDatabasesPath();
      String path = databasesPath + "/IoeSolutions.db";
      var database = await openDatabase("$path");
      var total = Sqflite.firstIntValue(
          await database.rawQuery('SELECT COUNT(*) FROM Subjects'));
      if (total > 0) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Faculty(
                  content_type: "syllabus",
                )));
      } else {
        final snackBar = SnackBar(
          duration: Duration(seconds: 5),
          content: Text(
            "Contents not available. Contents need to be fetched first to view in offline mode!",
            style: TextStyle(height: 1.8),
          ),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              _scaffoldKey.currentState.hideCurrentSnackBar();
            },
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    } catch (error) {
      final snackBar = SnackBar(
        duration: Duration(seconds: 5),
        content: Text(
          "Contents not available. Contents need to be fetched first to view in offline mode!",
          style: TextStyle(height: 1.8),
        ),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            _scaffoldKey.currentState.hideCurrentSnackBar();
          },
        ),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final Key _bannerAdKey = UniqueKey();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        print("Will pop scope called");
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime) > Duration(seconds: 2)) {
          if (alertDialogDisplayed == true) {
            return Future.value(false);
          }
          if (_scaffoldKey.currentState.isDrawerOpen &&
              alertDialogDisplayed == false) {
            Navigator.of(context).pop();
            return Future.value(false);
          }
          Fluttertoast.showToast(
              msg: "Press again to exit",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 12.0);
          currentBackPressTime = now;
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        drawer: generateDrawer(context, contentBloc),
        body: SafeArea(
          top: false,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  iconTheme: IconThemeData(color: Colors.white),
                  expandedHeight: screenHeight / 2.3,
                  floating: true,
                  pinned: true,
                  elevation: 0.0,
                  flexibleSpace: FlexibleSpaceBar(
                      title: Text("IOE  SOLUTIONS"),
                      collapseMode: CollapseMode.parallax,
                      background: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 0, color: Colors.white),
                          color: Colors.white,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xff860000),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(40.0),
                              bottomRight: Radius.circular(40.0),
                            ),
                          ),
                          child: Center(
                            child: Image.asset("images/logo.png", height: 120),
                          ),
                        ),
                      )),
                  backgroundColor: Color(0xff860000),
                ),
              ];
            },
            body: Container(
              padding: const EdgeInsets.only(top: 0),
              margin: const EdgeInsets.only(top: 0),
              color: Colors.white,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  //From here icons with wrap starts
                  BlocListener<HomepageBloc, HomepageState>(
                    listener: (context, state) {
                      if (state is HomepageDataLoaded &&
                          checkedForUpdate == false) {
                        setState(() {
                          checkedForUpdate = true;
                        });
                        print(
                            "Checking if update is needed after homepage data is loaded");
                        contentBloc.add(CheckForContentUpdate(
                            app_config: state.homepageData['app_config']));
                      }
                    },
                    child: BlocListener<ConnectivityBloc, ConnectivityState>(
                      listener: (context, state) {
                        if (state is HasInternetConnection) {
                          if (BlocProvider.of<HomepageBloc>(context).state
                              is! HomepageDataLoaded) {
                            BlocProvider.of<HomepageBloc>(context)
                                .add(LoadHomepageData());
                          }
                        }
                      },
                      child: Container(),
                    ),
                  ),
                  BlocProvider<ContentBloc>(
                    create: (context) => contentBloc,
                    child: BlocListener<ContentBloc, ContentState>(
                      listener: (context, state) {
                        if (state is LoadingNewContents) {
                          if (alertDialogDisplayed == false) {
                            print(
                                "alert Dialog displayed is : $alertDialogDisplayed");
                            setState(() {
                              checkedForUpdate = true;
                              alertDialogDisplayed = true;
                            });

                            return _showDialog(context,
                                "Fetching data for the first time.Please wait!!");
                          } else
                            return Container();
                        }
                        if (state is UpdatingContents) {
                          if (alertDialogDisplayed == false) {
                            setState(() {
                              checkedForUpdate = true;
                              alertDialogDisplayed = true;
                            });
                            return _showDialog(
                                context, "Updating contents.Please wait!!");
                          } else
                            return Container();
                        }
                        if (state is ContentLoadFailure) {
                          if (alertDialogDisplayed == true) {
                            print(
                                "alert Dialog displayed is : $alertDialogDisplayed");

                            print(
                                "alert Dialog displayed changed to : $alertDialogDisplayed");
                            setState(() {
                              checkedForUpdate = false;
                              alertDialogDisplayed = false;
                            });
                            Navigator.of(context).pop();
                          }
                          final snackBar = SnackBar(
                            content: Text(state.error["message"]),
                            action: SnackBarAction(
                              label: 'OK',
                              onPressed: () {
                                _scaffoldKey.currentState.hideCurrentSnackBar();
                              },
                            ),
                          );
                          Scaffold.of(context).showSnackBar(snackBar);
                        }
                        if (state is ContentSaved) {
                          print("saved");
                          if (alertDialogDisplayed == true) {
                            setState(() {
                              alertDialogDisplayed = false;
                              checkedForUpdate = true;
                            });
                            Navigator.of(context).pop();
                          }

                          final snackBar = SnackBar(
                            content:
                                Text('Contents have been saved successfully!'),
                            action: SnackBarAction(
                              label: 'OK',
                              onPressed: () {
                                _scaffoldKey.currentState.hideCurrentSnackBar();
                              },
                            ),
                          );
                          Scaffold.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          spacing: 30.0,
                          runSpacing: 30.0,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    _checkIfContentsExist();
                                  },
                                  child: Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xff860000)),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Icon(MyFlutterApp.book,
                                        color: Color(0xff860000)),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  'Syllabus',
                                  style: TextStyle(color: Color(0xff860000)),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) => Faculty(
                                                content_type: "questions",
                                              ))),
                                  child: Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xff860000)),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Icon(MyFlutterApp.survey,
                                        color: Color(0xff860000)),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  'Questions',
                                  style: TextStyle(color: Color(0xff860000)),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) => Faculty(
                                                content_type: "notes",
                                              ))),
                                  child: Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xff860000)),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Icon(MyFlutterApp.writing,
                                        color: Color(0xff860000)),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  'Notes',
                                  style: TextStyle(color: Color(0xff860000)),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) => NoticesList(),
                                  )),
                                  child: Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xff860000)),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Icon(MyFlutterApp.archive,
                                        color: Color(0xff860000)),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  'Notices',
                                  style: TextStyle(color: Color(0xff860000)),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) => NewsList(),
                                  )),
                                  child: Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xff860000)),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Icon(MyFlutterApp.writing,
                                        color: Color(0xff860000)),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  'News',
                                  style: TextStyle(color: Color(0xff860000)),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () async {
                                    return await _launchUrl(
                                        "https://www.youtube.com/channel/UC933Sl3-Q3Lz7OvgpSL0zSw");
                                  },
                                  // onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                                  //   builder: (context)=>MyDownloadPage())),
                                  child: Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xff860000)),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Center(
                                        child: Icon(MyFlutterApp.youtube_1,
                                            color: Color(0xff860000))),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  'Youtube',
                                  style: TextStyle(color: Color(0xff860000)),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () async {
                                    return await _launchUrl(
                                        "https://www.facebook.com/ioesolutions");
                                  },
                                  child: Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xff860000)),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Icon(MyFlutterApp.facebook_1,
                                        color: Color(0xff860000)),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  'Facebook',
                                  style: TextStyle(color: Color(0xff860000)),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () async {
                                    return await _launchUrl(
                                        "https://ioesolutions.esign.com.np/");
                                  },
                                  child: Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xff860000)),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Icon(MyFlutterApp.domain,
                                        color: Color(0xff860000)),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  'Website',
                                  style: TextStyle(color: Color(0xff860000)),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => ShowFolders(),
                                    ));
                                  },
                                  child: Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xff860000)),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Icon(MyFlutterApp.domain,
                                        color: Color(0xff860000)),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  'Extras',
                                  style: TextStyle(color: Color(0xff860000)),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xff860000)),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Icon(MyFlutterApp.review,
                                        color: Color(0xff860000)),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  'Rate Us',
                                  style: TextStyle(color: Color(0xff860000)),
                                )
                              ],
                            ),
                            SizedBox(height: 15.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  BlocBuilder(
                      bloc: BlocProvider.of<HomepageBloc>(context),
                      builder: (context, state) {
                        if (state is HomepageDataLoading) {
                          return loadingIndicator();
                        }
                        if (state is HomepageFailure) {
                          return Container();
                        }
                        if (state is HomepageDataLoaded) {
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    15.0, 0.0, 15.0, 0.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Recent News',
                                        style: TextStyle(
                                            color: Color(
                                              0xff860000,
                                            ),
                                            fontWeight: FontWeight.bold)),
                                    IconButton(
                                      icon: Icon(Icons.keyboard_arrow_right),
                                      onPressed: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  NewsList())),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Column(
                                children: _showRecentNews(
                                    state.homepageData['recent_news']),
                              ),
                              SizedBox(height: 10.0),
                              Container(
                                  key: _bannerAdKey,
                                  child: AdmobManager.finishBanner),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    15.0, 0.0, 15.0, 0.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Latest Notices',
                                        style: TextStyle(
                                            color: Color(
                                              0xff860000,
                                            ),
                                            fontWeight: FontWeight.bold)),
                                    IconButton(
                                      icon: Icon(Icons.keyboard_arrow_right),
                                      onPressed: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => NoticesList(),
                                      )),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Column(
                                children: _showRecentNotices(
                                    state.homepageData['recent_notices']),
                              ),
                            ],
                          );
                        }
                        return Container();
                      }),
                  SizedBox(height: 10.0),
                  AdmobManager.leaderBoard,
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

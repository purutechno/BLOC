import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget loadingIndicator() {
  return Center(
    child: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Loading... ",
            style: TextStyle(color: Colors.grey[600]),
          ),
          Container(
            height: 15,
            width: 15,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey[600]),
            ),
          ),
        ],
      ),
    ),
  );
}

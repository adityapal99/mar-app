import 'package:flutter/material.dart';

Widget loading_popup(BuildContext context) {
  return Container(
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      child: Container(
          width: MediaQuery.of(context).size.width / 1.5,
          height: 70,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
          child: Row(
            children: <Widget>[
              Container(padding: EdgeInsets.only(left: 10), child: CircularProgressIndicator()),
              Container(
                  padding: EdgeInsets.only(left: 30),
                  alignment: Alignment.center,
                  child: Text("Loading..."))
            ],
          )));
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() async {
  Map _data = await getData();
  List _features = _data['features'];
  var format = new DateFormat("MMM dd, yyyy hh:mm a");
  runApp(
    new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Quakes"),
          backgroundColor: Colors.blueGrey.shade900,
        ),
        backgroundColor: Colors.blueGrey.shade900,
        body: new ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: _features.length,
          itemBuilder: (BuildContext context, int position) {
            var date = new DateTime.fromMillisecondsSinceEpoch(
                _features[position]['properties']['time']);
            var dateString = format.format(date);

            var color = Colors.white54;
            if (_features[position]['properties']['mag'] < 1)
              color = Colors.blueAccent;
            else if (_features[position]['properties']['mag'] >= 1 &&
                _features[position]['properties']['mag'] < 2)
              color = Colors.green;
            else if (_features[position]['properties']['mag'] >= 2 &&
                _features[position]['properties']['mag'] < 4)
              color = Colors.orangeAccent;
            else if (_features[position]['properties']['mag'] >= 4 &&
                _features[position]['properties']['mag'] < 6)
              color = Colors.deepOrange;
            else if (_features[position]['properties']['mag'] >= 6)
              color = Colors.redAccent;

            return new Column(
              children: <Widget>[
                new ListTile(
                  title: new Text(
                    dateString,
                    style: new TextStyle(color: Colors.orangeAccent),
                  ),
                  subtitle: new Text(
                    _features[position]['properties']['place'],
                    style: new TextStyle(color: Colors.white54),
                  ),
                  leading: new CircleAvatar(
                    child: new Text(
                      double.parse(_features[position]['properties']['mag']
                              .toString())
                          .toStringAsFixed(2),
                      style: new TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                    ),
                    backgroundColor: color,
                  ),
                  onTap: (){showAlert(context, _features[position]['properties']['title']);},
                ),
                new Divider()
              ],
            );
          },
        ),
      ),
    ),
  );
}

Future<Map> getData() async {
  String _url =
      "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
  http.Response response = await http.get(_url);
  return jsonDecode(response.body);
}

void showAlert(BuildContext context, String message) {
  var alert = new AlertDialog(
    title: new Text("Quake"),
    content: new Text(message),
    actions: <Widget>[
      new FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: new Text("OK"))
    ],
  );
  showDialog(context: context, builder: (context)=>alert);
}

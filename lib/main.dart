import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(Mosam());
var url = "https://api.openweathermap.org/data/2.5/weather";
var apiKey = "399ac87a8ac9ca37d32b67fcb4ea98bb";

class Mosam extends StatefulWidget {
  @override
  _MosamState createState() => _MosamState();
}

class _MosamState extends State<Mosam> {
  String globalData;
  bool isLoading = true;

  Location location = new Location();

  // bool _serviceEnabled;
  // PermissionStatus _permissionGranted;
  LocationData _locationData;
  getLocation() async {
    try {
      if (await Permission.location.request().isGranted) {
        _locationData = await location.getLocation();
      }

      getWeatherData(_locationData.latitude, _locationData.longitude);
    } catch (e) {
      print(e);
    }
  }

  getWeatherData(latitude, longitude) async {
    var data;
    try {
      await http
          .get(url + "?lat=$latitude&lon=$longitude&appid=$apiKey")
          .then((res) => data = jsonDecode(res.body));
      data['cod'] == "404"
          ? globalData = data['message']
          : globalData = data['weather'][0]['description'];
      setState(() {
        isLoading = false;
      });
      print(data['weather'][0]['description']);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            child: Center(
              child: TextButton(
                onPressed: () {
                  getLocation();
                },
                child: isLoading
                    ? Image.asset(
                        "assets/loading.gif",
                      )
                    : Text(
                        globalData == null
                            ? "Press me to get weather"
                            : globalData,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

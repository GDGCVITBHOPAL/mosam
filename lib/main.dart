import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(Mosam());

class Mosam extends StatefulWidget {
  @override
  _MosamState createState() => _MosamState();
}

final url = "https://api.openweathermap.org/data/2.5/weather?";
final apiKey = "293372879a57bbe2071fb4abdb7e179d";

class _MosamState extends State<Mosam> {
  bool isLoading = true;
  var weatherData;

  getWeather(lat, lon) async {
    try {
      await http.get(url + "lat=$lat&lon=$lon&appid=$apiKey").then(
            (res) => weatherData = jsonDecode(res.body),
          );
      if (weatherData['cod'] == 200) {
        print(weatherData['weather'][0]['main']); //weather[0].main
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print(weatherData['cod']);
      }
    } catch (e) {
      print(e);
    }
  }

  getLocation() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (await Permission.location.request().isGranted) {
        LocationData location = await Location().getLocation();
        getWeather(location.latitude, location.longitude);
      }
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
      color: Colors.white,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            child: Center(
              child: isLoading
                  ? Image.asset("assets/loading.gif")
                  : TextButton(
                      onPressed: () {
                        getWeather("27.2046", "77.4977");
                      },
                      child: Text(
                        weatherData == null
                            ? "Click me!"
                            : weatherData['weather'] == null
                                ? weatherData['cod'].toString()
                                : weatherData['weather'][0]['main'].toString(),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

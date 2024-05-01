import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weather/weather.dart';
import 'package:weatherapp/consts.dart';

class weather extends StatefulWidget {
  const weather({super.key});

  @override
  State<weather> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<weather> {
  final WeatherFactory wf = WeatherFactory(open_weather_key);

  Weather? _weather;
  @override
  void initState() {
    super.initState();
    wf.currentWeatherByCityName("karachi").then((w) {
      setState(() {
        _weather = w;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _uibuild(),
    );
  }

  Widget _uibuild() {
    if (_weather == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: const Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [],
      ),
    );
  }
}

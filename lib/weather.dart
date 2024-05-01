import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    wf.currentWeatherByCityName("oslo").then((w) {
      setState(() {
        _weather = w;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 152, 186, 202),
      body: _uibuild(),
    );
  }

  Widget _uibuild() {
    if (_weather == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          weatherLocation(),
          const SizedBox(
            height: 20,
          ),
          locationdatetime(),
          weatherIcon(),
          locationTemperature(),
          const SizedBox(
            height: 30,
          ),
          locationhumidity(),
        ],
      ),
    );
  }

  Widget weatherLocation() {
    return Text(
      _weather?.areaName ?? "",
      style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
    );
  }

  Widget locationdatetime() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: const TextStyle(
            fontSize: 35,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(now),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "  ${DateFormat("d.mm.y").format(now)}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"),
            ),
          ),
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget locationTemperature() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)} °C",
      style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
    );
  }

  Widget locationhumidity() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 65,
      width: 300,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            "Humidity: ${_weather?.humidity?.toStringAsFixed(0)}",
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
          ),
          const Spacer(),
          Text(
            "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)} m/s",
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

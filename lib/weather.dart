import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weatherapp/consts.dart';

class weather extends StatefulWidget {
  const weather({Key? key}) : super(key: key);

  @override
  State<weather> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<weather> {
  final WeatherFactory wf = WeatherFactory(open_weather_key);
  TextEditingController citynamecontroller = TextEditingController();
  Weather? _weather;

  @override
  void initState() {
    super.initState();
    citynamecontroller = TextEditingController();
    fetchWeather("Karachi");
  }

  void fetchWeather(String name) {
    wf.currentWeatherByCityName(name).then((w) {
      setState(() {
        _weather = w;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 161, 196, 228),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: TextField(
              controller: citynamecontroller,
              decoration: InputDecoration(
                hintText: 'Enter city name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                fillColor: const Color.fromARGB(255, 144, 150, 158),
                filled: true,
                suffixIcon: IconButton(
                  onPressed: () {
                    fetchWeather(citynamecontroller.text);
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          Expanded(child: SingleChildScrollView(child: _buildUI())),
        ],
      ),
    );
  }

  Widget _buildUI() {
    if (_weather == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _weatherLocation(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          _locationDateTime(),
          _weatherIcon(),
          _locationTemperature(),
          _locationHumidity(),
        ],
      ),
    );
  }

  Widget _weatherLocation() {
    return Text(
      _weather?.areaName ?? "",
      style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
    );
  }

  Widget _locationDateTime() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: const TextStyle(
            fontSize: 30,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
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
              DateFormat("   d-M-y").format(DateTime.now()),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png",
              ),
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

  Widget _locationTemperature() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)} °C",
      style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
    );
  }

  Widget _locationHumidity() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 49, 54, 117),
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

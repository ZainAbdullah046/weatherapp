import 'package:flutter/material.dart';
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
          Expanded(child: _buildUI()),
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _weatherLocation(),
          const SizedBox(
            height: 20,
          ),
          _locationDateTime(),
          _weatherIcon(),
          _locationTemperature(),
          const SizedBox(
            height: 30,
          ),
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
              "  ${DateFormat("d - y").format(now)}",
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
          height: 100, // Adjust this height as needed
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
      style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
    );
  }

  Widget _locationHumidity() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 65,
      width: 300,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 37, 44, 133),
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

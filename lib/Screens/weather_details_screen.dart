import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_forecast/ApiKey.dart';

class WeatherDetails extends StatefulWidget {
  // City name passed from the previous screen
  final String cityName;
  const WeatherDetails({super.key, required this.cityName});

  @override
  State<WeatherDetails> createState() => _WeatherDetailsState();
}

class _WeatherDetailsState extends State<WeatherDetails> {
  // Factory to get weather data
  final WeatherFactory _factory = WeatherFactory(WEATHER_FORECAST_API_KEY);
  // Variable to store weather data
  Weather? _weather;
  // Variable to track loading state
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Fetch weather data when the screen is initialized
    _fetchWeather();
  }

// Function to fetch weather data
  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    // Fetch weather data using city name
    try {
      Weather weather = await _factory.currentWeatherByCityName(widget.cityName);
      setState(() {
        _isLoading = false;
        _weather = weather;
      });
    } on SocketException {
      setState(() {
        _isLoading = false;
        _errorMessage = "Network connection issue. Please check your internet connection.";
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        if (error.toString().contains('Error: Not found city')) {
          _errorMessage = "City not found. Please enter a valid city name.";
        } else {
          _errorMessage = " OOPS!!\nSomething went wrong\nPlease try again later.";
        }
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          // Refresh button to fetch weather data again
          IconButton(onPressed: _fetchWeather, icon: const Icon(Icons.refresh))
        ],
      ),
      // Build the UI based on the loading state and weather data
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (_isLoading) {
      return const Center(
        // Show loading indicator if data is still being fetched
        child: CircularProgressIndicator(),
      );
    }
    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.red, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      );
    }
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _locationheader(),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
          _Datetime(),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
          _weatherIcon(),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
          _currentTemp(),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
          _extraInfo(),
        ],
      ),
    );
  }

  Widget _locationheader() {
    return Text(
      _weather?.areaName ?? "", // Display area name if available
      style: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _Datetime() {
    DateTime now =
        _weather!.date!; // Get current date and time from weather data
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now), // Format and display time
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
              DateFormat("EEEE")
                  .format(now), // Format and display day of the week
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "  ${DateFormat("d.m.y").format(now)}", // Format and display date
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        )
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
          height: MediaQuery.sizeOf(context).height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png", // Load weather icon from network
              ),
            ),
          ),
        ),
        Text(
          _weather?.weatherDescription ??
              "", // Display weather description if available
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        )
      ],
    );
  }

  Widget _currentTemp() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C", // Display current temperature in Celsius
      style: const TextStyle(
        color: Colors.black,
        fontSize: 80,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _extraInfo() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.15,
      width: MediaQuery.sizeOf(context).width * 0.80,
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C", // Display maximum temperature
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Text(
                "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C", // Display minimum temperature
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)} m/s", // Display wind speed
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Text(
                "Humidity: ${_weather?.humidity?.toStringAsFixed(0)} %", // Display humidity
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}


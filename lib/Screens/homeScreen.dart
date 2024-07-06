// ignore: file_names
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_forecast/Screens/weather_details_screen.dart';

class Homescreen extends StatefulWidget {

  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final TextEditingController _cityname =
      TextEditingController();    
      String? _errorText;


      @override
  void initState() {
    super.initState();
    _loadLastSearchedCity();
  }

  // Load the last searched city from shared preferences
  Future<void> _loadLastSearchedCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _cityname.text = prefs.getString('lastSearchedCity') ?? '';
    });
  }

  // Save the city name to shared preferences
  Future<void> _saveCityName(String cityName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lastSearchedCity', cityName);
  }                    
   void _validateAndNavigate() {
    setState(() {
      // Validate city name
      if (_cityname.text.isEmpty) {
        _errorText = "City name cannot be empty";
      } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(_cityname.text)) {
        _errorText = "Invalid city name";
      } else {
        _errorText = null;
        _saveCityName(_cityname.text);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => WeatherDetails(
              cityName: _cityname.text,
            ),
          ),
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Weather Application",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            TextField(
              //  Controller to get the city name input
              controller: _cityname,                  
              decoration: InputDecoration(
                //Rounded border for the text field
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),               
                  ),
                ), 
                labelText: "Enter City",
                errorText: _errorText,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: 
                _validateAndNavigate
              ,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:
                    Colors.deepPurpleAccent, // Change the text color here
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text("Generate"),
            ),
          ],
        ),
      ),
    );
  }
}

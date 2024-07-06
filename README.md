# Weather Forecast Application

This Flutter application allows users to enter a city name and retrieve current weather information for that city. The app consists of two main screens: `Homescreen` and `WeatherDetails`.

## Features

- Enter a city name to fetch weather details.
- Store the last searched city using shared preferences.
- Display current weather information, including temperature, weather description, wind speed, and humidity.
- Handle errors such as invalid city names and network issues.

## Screens

### Homescreen

The `Homescreen` allows users to enter the name of a city and navigate to the `WeatherDetails` screen to view the weather information.

### WeatherDetails

The WeatherDetails screen displays the current weather information for the entered city, including temperature, weather description, wind speed, and humidity.

### How to Run

- Clone the repository.
- Add your OpenWeather API key in ApiKey.dart file.
- Run flutter pub get to install dependencies.
- Run flutter run to start the application.

### Dependencies

- flutter
- shared_preferences
- intl
- weather

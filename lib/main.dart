import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:http/http.dart" as http;
import "dart:convert";

void main() => runApp(MaterialApp(
    title: "Weather App",
    theme: ThemeData(primaryColor: Colors.red),
    home: Home()));

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  var temperature;
  var description;
  var currently;
  var humidity;
  var windSpeed;
  var city;
  Future getWeather() async {
    http.Response response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?units=metric&q=khartoum&appid=c002d310300ec150c7ee3e7b3b79e5b3"));
    var data = jsonDecode(response.body);
    // print("Data:");
    // print(data);
    setState(() {
      this.temperature = data["main"]["temp"];
      this.description = data["weather"][0]["description"];
      this.currently = data["weather"][0]["main"];
      this.humidity = data["main"]["humidity"];
      this.windSpeed = data["wind"]["speed"];
      this.city = data["name"];
    });
  }

  @override
  void initState() {
    super.initState();
    // this.getWeather();
  }

  @override
  Widget build(BuildContext ctx) {
    getWeather();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Shitty Weather app",
          ),
          backgroundColor: Colors.redAccent,
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(ctx).size.height / 3,
              width: MediaQuery.of(ctx).size.width,
              color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      "Currently in $city",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    temperature != null
                        ? temperature.round().toString() + "\u00B0"
                        : "Loading",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Sun",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                        title: Text("Temperature"),
                        trailing: Text(temperature != null
                            ? temperature.round().toString() + "\u00B0"
                            : "Loading"),
                      ),
                      ListTile(
                        leading: FaIcon(FontAwesomeIcons.cloud),
                        title: Text("Weather"),
                        trailing: Text(description != null
                            ? description.toString()
                            : "Loading"),
                      ),
                      ListTile(
                        leading: FaIcon(FontAwesomeIcons.sun),
                        title: Text(
                            humidity != null ? humidity.toString() : "Loading"),
                        trailing: Text("13"),
                      ),
                      ListTile(
                        leading: FaIcon(FontAwesomeIcons.wind),
                        title: Text("Wind Speed"),
                        trailing: Text(windSpeed != null
                            ? windSpeed.toString()
                            : "Loading"),
                      )
                    ],
                  )),
            )
          ],
        ));
  }
}

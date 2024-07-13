import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:weather_bloc_app/bloc/weather_bloc.dart';
import 'package:weather_bloc_app/data/screat_key.dart';

class SearchBoxPlace extends StatefulWidget {
  const SearchBoxPlace({super.key});

  @override
  State<SearchBoxPlace> createState() => _SearchBoxPlaceState();
}

class _SearchBoxPlaceState extends State<SearchBoxPlace> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GooglePlaceAutoCompleteTextField(
      textEditingController: controller,
      textStyle: TextStyle(color: Colors.white),
      googleAPIKey: googleApi,
      inputDecoration: InputDecoration(
        hintText: "Enter the city ",
        hintStyle: TextStyle(color: Colors.white),
        prefixIcon: Icon(Icons.location_on),
      ),
      debounceTime: 800, // default 600 ms,
      countries: ["in", "fr"], // optional by default null is set
      isLatLngRequired: true, // if you required coordinates from place detail
      getPlaceDetailWithLatLng: (Prediction prediction) {
        // this method will return latlng with place detail
     
       

        context.read<WeatherBloc>().add(WeatherFetchByCity(prediction));
      }, // this callback is called when isLatLngRequired is true
      itemClick: (Prediction prediction) {
        controller.text = prediction.description!;
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: prediction.description!.length));
      },
      // if we want to make custom list item builder
      itemBuilder: (context, index, Prediction prediction) {
        return Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(Icons.location_on),
              SizedBox(
                width: 7,
              ),
              Expanded(child: Text(prediction.description ?? ""))
            ],
          ),
        );
      },
      // if you want to add seperator between list items
      seperatedBuilder: Divider(),
      // want to show close icon
      isCrossBtnShown: true,
      // optional container padding
      containerHorizontalPadding: 10,
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_bloc_app/db/model/data_model.dart';

ValueNotifier<DataModel> predict = ValueNotifier(Prediction as DataModel);

void addData(DataModel val) async {
  final db = await Hive.openBox('data_db');
  await db.put(1, val);
}

Future<Prediction?> getData() async {
  final db = await Hive.openBox('data_db');
  print('--------------------------------------');
  print(db.get(1));
  return  db.get(1);
}

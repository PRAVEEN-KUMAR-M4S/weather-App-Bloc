import 'package:google_places_flutter/model/prediction.dart';
import 'package:hive_flutter/adapters.dart';
part 'data_model.g.dart';


@HiveType(typeId: 1)
class DataModel {
  @HiveField(0)
  final Prediction prediction;

  DataModel({required this.prediction});
}

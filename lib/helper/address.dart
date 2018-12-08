import 'package:cloud_firestore/cloud_firestore.dart';

class Address {
  String line1FS = "line1";
  String line2FS = "line2";
  String kampungFS = "kampung";
  String districtFS = "district";
  String countryFS = "country";
  String geoPointFS = "geoPoint";

  String line1;
  String line2; //optional
  String kampung;
  String district;
  String country;
  GeoPoint geoPoint;

  Address();

  Address.fromMap(Map<String, dynamic> map){
    this.line1 = map[line1FS];
    this.line2 = map[line2FS] ?? "";
    this.kampung = map[kampungFS];//todo Kampung should be enum
    this.district = map[districtFS];
    this.country = map[countryFS];
    this.geoPoint = map[geoPointFS];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      line1FS : line1,
      kampungFS : kampung,
      districtFS : district,
      countryFS : country,
      geoPointFS : geoPoint,
    };
    if (line2 != "") map.addAll({line2FS : line2});
    return map;
  }

  @override
  String toString() => "$line1, ${line2 ?? ""}, $kampung, $district, $country";
  
}

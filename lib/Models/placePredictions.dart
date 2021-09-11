class PlacePredictions {
  // ignore: non_constant_identifier_names
  var secondary_text;
  // ignore: non_constant_identifier_names
  var main_text;
  // ignore: non_constant_identifier_names
  var place_id;

  // ignore: non_constant_identifier_names
  PlacePredictions({this.secondary_text, this.main_text, this.place_id});

  PlacePredictions.fromJson(Map<String, dynamic> json) {
    place_id = json["place_id"];
    secondary_text = json["structured_formatting"]["secondary_text"];
    main_text = json["structured_formatting"]["main_text"];
  }
}

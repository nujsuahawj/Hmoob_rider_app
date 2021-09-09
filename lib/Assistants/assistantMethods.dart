import 'package:geolocator/geolocator.dart';
import 'package:rider_app/Assistants/requestAssistant.dart';

import '../configMaps.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(Position position) async {
    // ignore: unused_local_variable
    String placeAddress = "";
    // ignore: unused_local_variable
    var url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    // ignore: unused_local_variable
    var response = await RequestAssistant.getRequest(url);
    if (response != "failed") {
      placeAddress = response["results"][0]["formatted_address"];
    }
    return placeAddress;
  }
}

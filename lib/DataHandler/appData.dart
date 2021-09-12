import 'package:flutter/foundation.dart';
import 'package:rider_app/Models/address.dart';

class AppData extends ChangeNotifier {
  late Address pickUpLocation, dropOffLocation;
  void updatePickUpLocationAdress(Address pickUpAddress) {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }
   void updateDropOffLocationAdress(Address dropOffAddress) {
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }
}

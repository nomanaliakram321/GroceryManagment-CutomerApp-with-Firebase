import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider with ChangeNotifier {
  double latitude;
  double longitude;
  bool permissionAllowed = false;
  var selectedAddress;
  bool loading = false;
  Future<Void> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (position != null) {
      this.latitude = position.latitude;
      this.longitude = position.longitude;

      final coordinate = new Coordinates(this.latitude, this.longitude);
      final addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinate);
      this.selectedAddress = addresses.first;

      permissionAllowed = true;
      notifyListeners();
    } else {
      print("Permission are denied");
    }
  }

  void onCameraMove(CameraPosition cameraposition) async {
    this.latitude = cameraposition.target.latitude;
    this.longitude = cameraposition.target.longitude;
    notifyListeners();
  }

  Future<void> getMoveCamera() async {
    final coordinates = new Coordinates(this.latitude, this.longitude);
    final address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    this.selectedAddress = address.first;
    notifyListeners();
    print("${selectedAddress.featureName}: ${selectedAddress.addressLine}");
  }

  Future<Void> savePrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setDouble('latitude', this.latitude);
    preferences.setDouble('longitude', this.longitude);
    preferences.setString('address', this.selectedAddress.addressLine);
    preferences.setString('location', this.selectedAddress.featureName);
  }
}

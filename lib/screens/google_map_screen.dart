import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:mighty_properties/main.dart';
import '../components/app_bar_components.dart';
import '../extensions/common.dart';
import '../models/place_address_model.dart';
import '../utils/constants.dart';

class GoogleMapScreen extends StatefulWidget {
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);
  final bool isPick;
  final bool isFromMap;
  final bool isFromFilter;

  final Function(double, double)? onLatLong;
  final Function(String?)? onAddress;
  final Function(String, String, String)? cityCountryState;

  const GoogleMapScreen({this.isPick = true, this.onAddress, this.onLatLong, this.cityCountryState, this.isFromMap = false, this.isFromFilter = false});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  PickResult? selectedPlace;
  bool showPlacePickerInContainer = false;
  bool showGoogleMapInContainer = false;
  String? fullAddress;
  double? mapLatitude;
  double? mapLongitude;
  String city = "";
  String country = "";
  String state = "";
  String conCateString = "";
  List<String> addressParts = [];

  @override
  void initState() {
    super.initState();
  }

  void sendAddress() {
    widget.onAddress!(fullAddress);
  }

  void sendCityStateCountry() {
    widget.cityCountryState!(city, state, country);
  }

  void sendLatLong() {
    widget.onLatLong!(mapLatitude!, mapLongitude!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language.chooseLocation, context1: context, titleSpace: 0, showBack: true),
      body: PlacePicker(
        apiKey: GOOGLE_API_KEY,
        hintText: language.searchAddress,
        searchingText: language.pleaseWait,
        selectText: language.confirmAddress,
        initialPosition: GoogleMapScreen.kInitialPosition,
        useCurrentLocation: true,
        selectInitialPosition: true,
        usePinPointingSearch: true,
        usePlaceDetailSearch: true,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        automaticallyImplyAppBarLeading: false,
        // autocompleteLanguage: appStore.selectedLanguage,
        onMapCreated: (GoogleMapController controller) {
          //
        },
        onPlacePicked: (PickResult result) {
          setState(() {
            selectedPlace = result;
            PlaceAddressModel selectedModel = PlaceAddressModel(
              placeId: selectedPlace!.placeId!,
              latitude: selectedPlace!.geometry!.location.lat,
              longitude: selectedPlace!.geometry!.location.lng,
              placeAddress: selectedPlace!.formattedAddress,
            );
            // finish(context, selectedModel);
            Navigator.pop(context);
            fullAddress = selectedModel.placeAddress.toString();
            mapLatitude = selectedModel.latitude!.toDouble();
            mapLongitude = selectedModel.longitude!.toDouble();
            addressParts = fullAddress!.split(',');
            conCateString = addressParts.sublist(addressParts.length - 3).join(',');
            List<String> modifiedAddress = conCateString.split(',');
            city = modifiedAddress[0].trim();
            state = modifiedAddress.length >= 1 ? modifiedAddress[1].trim() : "";
            int indexOfPostalCode = state.lastIndexOf(' ');
            if (indexOfPostalCode != -1) {
              state = state.substring(0, indexOfPostalCode);
              setState(() {});
            }
            country = modifiedAddress.last.trim();
            if (widget.isFromMap) {
              widget.onLatLong!(mapLatitude!, mapLongitude!);
              sendAddress();
              sendCityStateCountry();
            } else if (widget.isFromFilter) {
              widget.onLatLong!(mapLatitude!, mapLongitude!);
              sendAddress();
            } else {
              toast(language.somethingWentWrong);
            }
          });
          setState(() {});
        },
        onMapTypeChanged: (MapType mapType) {
          //
        },
      ),
    );
  }
}

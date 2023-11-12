import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  LatLng _center = LatLng(35.88804, 128.61135);
  TextEditingController controller = TextEditingController();
  List<Marker> markers = [];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<Position> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    return position;
  }

  @override
  void initState() {
    super.initState();
    _loadLocation();
    _fetchMarkersFromFirebase();
  }

  Future<void> _fetchMarkersFromFirebase() async {
    CollectionReference dataRef = FirebaseFirestore.instance.collection('data');
    QuerySnapshot querySnapshot = await dataRef.get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        markers = querySnapshot.docs.map((doc) {
          double latitude = doc['latitude'];
          double longitude = doc['longitude'];

          return Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(latitude, longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          );
        }).toList();
      });
    }
  }

  Future<void> _loadLocation() async {
    var status = await Permission.location.status;

    if (status == PermissionStatus.granted) {
      Position position = await getLocation();
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
      });
    } else {
      var permissionStatus = await Permission.location.request();
      if (permissionStatus.isGranted) {
        _loadLocation();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('연탄 급식소'),
          backgroundColor: Colors.green[700],
        ),
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(_center.latitude, _center.longitude),
                zoom: 15.0,
              ),
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              markers: Set<Marker>.of(markers),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: MediaQuery.of(context).size.width * 0.15,
              child: placesAutoCompleteTextField(),
            ),
          ],
        ),
      ),
    );
  }

  Widget placesAutoCompleteTextField() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.14,
      padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: controller,
        googleAPIKey: "AIzaSyACnsP52Pv3MYsHCQZK0CvRXB15rK6S014",
        inputDecoration: InputDecoration(
          hintText: "검색어를 입력하세요",
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 8, right: 8),
        ),
        debounceTime: 400,
        countries: ["kr"],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          double lat = double.parse(prediction.lat.toString());
          double lng = double.parse(prediction.lng.toString());

          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(lat, lng),
                zoom: 15.0,
              ),
            ),
          );
        },
        itemClick: (Prediction prediction) async {
          controller.text = prediction.description ?? "";
        },
        itemBuilder: (context, index, Prediction prediction) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(
                  width: 7,
                ),
                Expanded(child: Text("${prediction.description ?? ""}"))
              ],
            ),
          );
        },
        isCrossBtnShown: true,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class MapPage extends StatefulWidget{
  const MapPage({super.key});

  @override
  _MapPage createState() => _MapPage();
}

class _MapPage extends State<MapPage>{
  late GoogleMapController mapController;
  
  LatLng _center = LatLng(35.88804, 128.61135);

  TextEditingController controller = TextEditingController();

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
  }

// 현재위치 가져옴
  Future<void> _loadLocation() async {
    // 권한이 부여되었는지 확인
    var status = await Permission.location.status;

    if (status == PermissionStatus.granted) {
      // 권한이 부여되었으면 위치를 가져옵니다
      Position position = await getLocation();
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
      });
    } else {
        // 권한이 부여되지 않았으면 권한을 요청합니다
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
            // GoogleMap Widget
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(_center.latitude, _center.longitude),
                zoom: 15.0,
              ),
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
            ),
            // Search bar using GooglePlaceAutoCompleteTextField
            Positioned(
            top: 0,
              left: 0,
              right: MediaQuery.of(context).size.width*0.15,
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
      width: MediaQuery.of(context).size.width*0.5,
      height: MediaQuery.of(context).size.width*0.14,
      padding: EdgeInsets.fromLTRB(2,2,2,2),
        child: GooglePlaceAutoCompleteTextField(
          textEditingController: controller,
          googleAPIKey: "AIzaSyACnsP52Pv3MYsHCQZK0CvRXB15rK6S014",
          inputDecoration: InputDecoration(
            hintText: "검색어를 입력하세요",
            filled: true,
            fillColor: Colors.white,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 8, right: 8), // 내부 여백을 최소화합니다.
          ),
          debounceTime: 400,
          countries: ["kr"],
          isLatLngRequired: true,
          getPlaceDetailWithLatLng: (Prediction prediction) {
            print("placeDetails : " + prediction.lat.toString());
            print("placeDetails : " + prediction.lng.toString());
            
            double lat = double.parse(prediction.lat.toString());
            double lng = double.parse(prediction.lng.toString());

            // 선택한 위치로 GoogleMap의 카메라를 이동
            mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(lat, lng),
                      zoom: 15.0,  // 줌 레벨 설정
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
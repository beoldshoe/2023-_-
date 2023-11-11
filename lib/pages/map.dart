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
          title: const Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
         body: 
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
        
        ),
    );
  }
}


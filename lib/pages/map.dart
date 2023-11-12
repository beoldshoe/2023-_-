import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapPage extends StatefulWidget{
  const MapPage({super.key});

  @override
  _MapPage createState() => _MapPage();
}

class _MapPage extends State<MapPage>{
  late GoogleMapController mapController;
  
  LatLng _center = LatLng(35.88804, 128.61135);

  TextEditingController controller = TextEditingController();

  Set<Marker> _markers = {};
  String selectedDay = '요일';  // 선택한 요일을 저장할 변수
  String selectedMeal = '식사 시간 / 방법'; 
  String selectedTarget = '대상 선택'; 

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // 요일 선택 시
  void showDayPickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: 9,
          itemBuilder: (BuildContext context, int index) {
            String title;
            String dayForDb;
            switch (index) {
              case 0:
                title = '월';
                dayForDb = '1';
                break;
              case 1:
                title = '화';
                dayForDb = '2';
                break;
              case 2:
                title = '수';
                dayForDb = '3';
                break;
              case 3:
                title = '목';
                dayForDb = '4';
                break;
              case 4:
                title = '금';
                dayForDb = '5';
                break;
              case 5:
                title = '토';
                dayForDb = '6';
                break;
              case 6:
                title = '일';
                dayForDb = '7';
                break;
              case 7:
                title = '비정기';
                dayForDb = '8';
                break;
              default:
                title = '요일';
                dayForDb = '0';
                break;
            }
            return ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text(title),
              onTap: () {
                setState(() {
                  selectedDay = title;  // 선택한 요일을 변수에 저장합니다.
                  _markers.clear();  // 기존의 마커를 모두 지웁니다.
                  if (dayForDb == '0') {  // '전체'를 선택한 경우 모든 마커를 불러옵니다.
                    loadMarkers();
                  } else {  // 특정 요일을 선택한 경우 해당 요일의 마커만 불러옵니다.
                    loadMarkersByDay(dayForDb);
                  }
                });
                Navigator.pop(context);  // 다이얼로그를 닫습니다.
              },
            );
          },
        );
      },
    );
  }

    // 대상 선택 시
  void showTargetPickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: 9,
          itemBuilder: (BuildContext context, int index) {
            String title;
            switch (index) {
              case 0:
                title = '60세 이상';
                break;
              case 1:
                title = '65세 이상';
                break;
              case 2:
                title = '70세 이상';
                break;
              case 3:
                title = '저소득층';
                break;
              case 4:
                title = '장애인';
                break;
              case 5:
                title = '아동';
                break;
              case 6:
                title = '노숙인';
                break;
              case 7:
                title = '외국인';
                break;
              default:
                title = '대상전체';
                break;
            }
            return ListTile(
              leading: Icon(Icons.people),
              title: Text(title),
              onTap: () {
                setState(() {
                  selectedTarget = title;  // 선택한 대상을 변수에 저장합니다.
                  _markers.clear();  // 기존의 마커를 모두 지웁니다.
                  loadMarkersByTarget(title);  // 선택한 대상에 해당하는 마커를 불러옵니다.
                });
                Navigator.pop(context);  // 다이얼로그를 닫습니다.
              },
            );
          },
        );
      },
    );
  }

// 식사 시간/방법 선택 시
  void showMealPickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            String title;
            String meal;
            switch (index) {
              case 0:
                title = '조식';
                meal = "0";
                break;
              case 1:
                title = '중식';
                meal = "1";
                break;
              case 2:
                title = '석식';
                meal = "2";
                break;
              case 3:
                title = '배달';
                meal = "3";
                break;
              default:
                title = '식사 시간/방법';
                meal = "4";
                break;
            }
            return ListTile(
              leading: Icon(Icons.restaurant),
              title: Text(title),
              onTap: () {
                setState(() {
                  selectedMeal = title;  // 선택한 식사 시간/방법에 대응하는 값을 변수에 저장합니다.
                  _markers.clear();  // 기존의 마커를 모두 지웁니다.
                  if(meal == '4'){
                    loadMarkers();
                  }
                  else{
                    loadMarkersByMeal(meal);
                  }
                  
                });
                Navigator.pop(context);  // 다이얼로그를 닫습니다.
              },
            );
          },
        );
      },
    );
  }
  //마커 추가하기
  void _addMarker(LatLng position, String title, Map<String, dynamic> data) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          infoWindow: InfoWindow(title: title),
          onTap: () {
            showDetailsDialog(data);
          },
        ));
    });
  }

  // 마커 찍기
  Future<void> loadMarkers() async {
    CollectionReference collection = FirebaseFirestore.instance.collection('data');
    QuerySnapshot querySnapshot = await collection.get();
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data != null) {
        double lat = double.parse(data['latitude'] ?? '0');
        double lng = double.parse(data['logitude'] ?? '0');
        String title = data['facility_name'] ?? '';
        _addMarker(LatLng(lat, lng), title, data);
      }
    });
    print('All markers: $_markers');
  }

  //요일별로 마커 찍기
  Future<void> loadMarkersByDay(String day) async {
    CollectionReference collection = FirebaseFirestore.instance.collection('data');
    QuerySnapshot querySnapshot = await collection.where('day_for_db', isGreaterThanOrEqualTo: day).get();
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data != null) {
        double lat = double.parse(data['latitude'] ?? '0');
        double lng = double.parse(data['logitude'] ?? '0');
        String title = data['facility_name'] ?? '';
        String dayForDb = data['day_for_db'] ?? '';
        if (dayForDb.contains(day)) {  // 선택한 요일이 day_for_db에 포함되어 있으면 마커를 추가합니다.
          _addMarker(LatLng(lat, lng), title, data);
        }
      }
    });
    print('All markers: $_markers');
  }

  //대상별로 마커 찍기
  Future<void> loadMarkersByTarget(String target) async {
    CollectionReference collection = FirebaseFirestore.instance.collection('data');
    QuerySnapshot querySnapshot;

    if (target == '대상전체') {
      querySnapshot = await collection.get();  // 대상전체를 선택한 경우 모든 문서를 가져옵니다.
    } else {
      querySnapshot = await collection.where('target_for_db', isEqualTo: target).get();  // 특정 대상을 선택한 경우 해당 대상을 포함하는 문서만 가져옵니다.
    }

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data != null) {
        double lat = double.parse(data['latitude'] ?? '0');
        double lng = double.parse(data['logitude'] ?? '0');
        String title = data['facility_name'] ?? '';
        _addMarker(LatLng(lat, lng), title, data);
      }
    });
    print('All markers: $_markers');
  }

  // 현재 위치 받아오기
  Future<Position> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    return position;
  }

  //식사 시간/방법별로 마커 찍기
  Future<void> loadMarkersByMeal(String meal) async {
    CollectionReference collection = FirebaseFirestore.instance.collection('data');
    QuerySnapshot querySnapshot;

    if (meal == '식사 시간/방법') { // '식사 시간/방법'을 선택한 경우 모든 문서를 가져옵니다.
      querySnapshot = await collection.get();  
    } else {
      querySnapshot = await collection.where('time_for_db', isGreaterThanOrEqualTo: meal).get();  // 특정 식사 시간/방법을 선택한 경우 해당 식사 시간/방법 이상인 값을 가지는 문서를 가져옵니다.
    }

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data != null) {
        double lat = double.parse(data['latitude'] ?? '0');
        double lng = double.parse(data['logitude'] ?? '0');
        String title = data['facility_name'] ?? '';
        String timeForDb = data['time_for_db'] ?? '';
        if (timeForDb == meal) {  // 선택한 식사 시간/방법에 대응하는 값만 마커를 추가합니다.
          _addMarker(LatLng(lat, lng), title, data);
        }
      }
    });
    print('All markers: $_markers');
  }

  // 상세 내용 보여주기
  void showDetailsDialog(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(data['facility_name'] ?? ''),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('주소: ' + (data['address'] ?? '')),
                Text('운영 기관: ' + (data['operating_institution'] ?? '')),
                Text('전화번호: ' + (data['phone_number'] ?? '전화번호 정보 없음')),
                Text('대상: ' + (data['target'] ?? '')),
                Text('시간: ' + (data['time'] ?? '')),
                Text('요일: ' + (data['day'] ?? '')),
                Text('제공자: ' + (data['provider'] ?? '')),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadLocation();
    loadMarkers();
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
              title: Text(
                '연탄 급식소',
                style: TextStyle(
                  color: Colors.black,  // 글씨 색깔을 검은색으로 설정
                ),
              ),
          backgroundColor: Color(0xFFF7F2FA),  // AppBar의 색상을 #F7F2FA로 설정
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
              markers: _markers,
            ),
            // Search bar using GooglePlaceAutoCompleteTextField
            Positioned(
            top: 0,
              left: 0,
              right: MediaQuery.of(context).size.width*0.15,
              child: placesAutoCompleteTextField(),
            ),
          // Elevator buttons
          Positioned(
            top: MediaQuery.of(context).size.width*0.14,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: showDayPickerDialog,  // '요일' 버튼을 누르면 요일 선택 다이얼로그가 표시됩니다.
                  child: Text(selectedDay),  // 버튼의 텍스트를 선택한 요일로 설정합니다.
                ),

                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: showTargetPickerDialog,  // '대상 선택' 버튼을 누르면 대상 선택 다이얼로그가 표시됩니다.
                  child: Text(selectedTarget),
                ),

                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: showMealPickerDialog,  // '식사 tlr' 버튼을 누르면 대상 선택 다이얼로그가 표시됩니다.
                  child: Text(selectedMeal),
                ),
              ],
            ),
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
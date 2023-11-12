import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListPage extends StatefulWidget {
  const ListPage ({super.key});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final List<String> regions = ["서울","대구","부산","광주","인천","대전","울산","경기도","경상남도","경상북도","전라남도","전라북도","충청남도","충청북도","강원","제주","기타"];
  String selectedRegion = '서울';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton<String>(
          value: selectedRegion,
          items: regions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              selectedRegion = newValue!;
            });
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text("무료급식소 리스트", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 100,
              width: 100,
              child: Lottie.asset("lottie/list.json"),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('data').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      if (selectedRegion == '기타') {
                        if (regions.where((region) => data['provider'].contains(region)).isEmpty) {
                          return buildCard(data);
                        }
                      } else {
                        if (data['provider'].contains(selectedRegion)) {
                          return buildCard(data);
                        }
                      }
                      return Container();
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card buildCard(Map<String, dynamic> data) {
    return Card(
      child: ListTile(
        title: Text('Facility Name: ${data['facility_name']}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Operating Institution: ${data['operating_institution']}'),
            Text('Place: ${data['place']}'),
            Text('Provider: ${data['provider']}'),
            Text('Target: ${data['target']}'),
            Text('Time: ${data['time']}'),
            Text('Phone number: ${data['phone_number']}'),
            Text('Day: ${data['day']}'),
          ],
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:respal/login_page.dart';
import 'main.dart';
import 'package:dio/dio.dart';

class MainPage extends StatefulWidget {
  final String refreshToken;
  const MainPage(this.refreshToken);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final formKey = GlobalKey<FormState>();
  String refreshToken = "";

  @override
  void initState() {
    super.initState();
    refreshToken = widget.refreshToken;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: (){}
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: (){}
          )
        ],
      ),
      body: new Container(
        padding: EdgeInsets.all(16),
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Text'),
              ),
              new ElevatedButton(
                  child: new Text(
                    'Logout',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  onPressed:(){
                    Logout(context, refreshToken);
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> Logout(BuildContext context, String refreshToken) async {
  final dio = Dio(); // Dio 인스턴스 생성
  final response = await dio.post(
    'http://api-respal.me/member/logout',
    options: Options(
      headers: {
        'Authorization': 'Bearer $refreshToken',
      },
    ),
  );

  logger(response.statusCode);
  logger(response.data);
  // 응답 처리
  if (response.statusCode == 200) {
    // 토큰을 성공적으로 받아온 경우
    final jsondata = response.data;



    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );

    // 받아온 토큰을 앱에서 저장하거나 관리하는 로직을 구현합니다.
    // sharedpreference로 저장
  } else {
    // 오류가 발생한 경우
    print('Error: ${response.statusCode}');
    // 오류 처리 로직을 구현합니다.
    // ...
  }

}
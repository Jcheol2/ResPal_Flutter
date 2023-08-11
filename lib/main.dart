import 'package:flutter/material.dart';
import 'view/Main_page.dart';
import 'view/Login_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';


void main() {
  runApp(new MyApp());
}

// 여기서 sharedprefrence에 따라 로그인 페이지 or 메인페이지로 분기
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ResPal',
      // home: new MainPage("refreshToken"),
      home: new LoginPage(),
    );
  }
}

void showToast(String message){
  Fluttertoast.showToast(msg: message,
      backgroundColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM
  );
}

void logger(dynamic message){
  var logger = Logger();
  logger.d(message);
}
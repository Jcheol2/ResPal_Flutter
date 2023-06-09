import 'package:flutter/material.dart';
import 'main.dart';
import 'package:dio/dio.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();

  String? _name;
  String? _email;
  String? _password;
  String? _nickname;
  String? _image;
  
  void validateAndSave() {
    final form = formKey.currentState;
    if (form?.validate() ?? false) {
      form?.save();
      print('Form is valid Email: $_email, password: $_password');
    } else {
      print('Form is invalid Email: $_email, password: $_password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
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
                decoration: new InputDecoration(labelText: 'Name'),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Name can\'t be empty' : null,
                onSaved: (value) => _name = value ?? '',
              ),
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Email'),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Email can\'t be empty' : null,
                onSaved: (value) => _email = value ?? '',
              ),
              new TextFormField(
                obscureText: true,
                decoration: new InputDecoration(labelText: 'Password'),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Password can\'t be empty' : null,
                onSaved: (value) => _password = value ?? '',
              ),
              new TextFormField(
                obscureText: true,
                decoration: new InputDecoration(labelText: 'NickName'),
                validator: (value) =>
                value?.isEmpty ?? true ? 'NickName can\'t be empty' : null,
                onSaved: (value) => _nickname = value ?? '',
              ),
              new TextFormField(
                obscureText: true,
                decoration: new InputDecoration(labelText: 'Image'),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Image can\'t be empty' : null,
                onSaved: (value) => _image = value ?? '',
              ),
              new ElevatedButton(
                child: new Text(
                  'Sign Up',
                  style: new TextStyle(fontSize: 20.0),
                ),
                onPressed:(){
                  validateAndSave;
                  SignupToCommon(context, _email!, _password!, _nickname!, _image!);
                },
              ),
              new ElevatedButton(
              child: new Text(
                'Cancel',
                style: new TextStyle(fontSize: 20.0),
              ),
                  onPressed: () {
                Navigator.pop(context);
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> SignupToCommon(BuildContext context, String email, String password, String picture, String nickname) async {
  final dio = Dio(); // Dio 인스턴스 생성
  try {
    final response = await dio.post(
      'http://api-respal.me/member/join', // 백엔드 API 엔드포인트 URL
      data: {
        "email": email, // required
        "password": password, // 일반회원은 필수, oauth는 null
        "picture": picture, // oauth login시 받은 image 자동 세팅
        "nickname": nickname,
        "provider": "common" // required
      },
    );

    logger(response);
    logger(response.statusCode);
    logger(response.data);

    // 응답 처리
    if (response.statusCode == 201) {
      // 토큰을 성공적으로 받아온 경우
      // 받아온 토큰을 앱에서 저장하거나 관리하는 로직을 구현합니다.
      // sharedpreference로 저장
      final jsondata = response.data;

      final accessToken = jsondata['data']['accessToken'];
      final refreshToken = jsondata['data']['refreshToken'];
      logger(accessToken);
      logger(refreshToken);

      Navigator.pop(context);
    } else {
      // 오류가 발생한 경우
      print('Error: ${response.statusCode}');
      // 오류 처리 로직을 구현합니다.
      // ...
    }
  } catch (e) {
    // 네트워크 요청 실패 등 예외가 발생한 경우
    print('Exception occurred: $e');
    // 예외 처리 로직을 구현합니다.
    // ...
  }
}
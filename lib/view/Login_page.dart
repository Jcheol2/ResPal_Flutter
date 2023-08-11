import 'package:flutter/material.dart';
import 'FindAccount_page.dart';
import '../main.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:dio/dio.dart';
import 'Main_page.dart';
import 'SignUp_page.dart';
import '../data/remote/api/RetrofitConfig.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  RetrofitConfig retrofitConfig = new RetrofitConfig();
  String? _email;
  String? _password;
  String? _emailError;
  String? _passwordError;

  void validateAndSave() {
    final form = formKey.currentState;
    if (form?.validate() ?? false) {
      form?.save();
      retrofitConfig.sendCommonToBackend(context, _email!, _password!);
      print('Form is valid Email: $_email, password: $_password');
    } else {
      print('Form is invalid Email: $_email, password: $_password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: _buildLoginForm(),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(top: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 20),
          Image.asset(
            'images/title_ic.png',
            width: 120,
            height: 45,
          ),
          SizedBox(height: 30),
          Text(
            'Respal에 오신것을 환영합니다.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Respal은 개발자를 위한 이력서 공유 플랫폼입니다.',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          Text(
            'SNS 로그인',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          Row(
            children: [
              Expanded(
                child: IconButton(
                  icon: Image.asset('images/github.png'),
                  onPressed: () {
                    retrofitConfig.signInOauth(context, "github");
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Image.asset('images/google.png'),
                  onPressed: () {
                    retrofitConfig.signInOauth(context, "google");
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Image.asset('images/kakao.png'),
                  onPressed: () {
                    retrofitConfig.signInOauth(context, "kakao");
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          _buildHorizontalLineText(), //메서드
          SizedBox(height: 10),
          Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Email TextFormField
                Text(
                  'Email',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 10),
                _buildEmailFormField(), //메서드
                if (_emailError != null)
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Visibility(
                      visible: _emailError != null,
                      child: Text(
                        _emailError!,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                SizedBox(height: 30),
                // Password TextFormField
                Text(
                  'PassWord',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 10),
                _buildPasswordFormField(), //메서드
                if (_passwordError != null)
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Visibility(
                      visible: _passwordError != null,
                      child: Text(
                        _passwordError!,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FindAccountPage()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                    ),
                    child: Text(
                      "계정찾기",
                      style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF3B3B3B)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  child: Text(
                    '로그인',
                    style: TextStyle(fontSize: 12),
                  ),
                  onPressed: () {
                    validateAndSave();
                    retrofitConfig.sendCommonToBackend(context, _email!, _password!);
                  },
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '아직 회원이 아니신가요?',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(width: 1),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignupPage()),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                        ),
                        child: Text(
                          "회원가입",
                          style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailFormField() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 30.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(6.5),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value?.isEmpty ?? true) {
            _emailError = 'Email can\'t be empty';
            return null;
          }
          _emailError = null;
          return null;
        },
        onSaved: (value) => _email = value ?? '',
      ),
    );
  }

  Widget _buildPasswordFormField() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 30.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(6.5),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value?.isEmpty ?? true) {
            _passwordError = 'Password can\'t be empty';
            return null;
          }
          _passwordError = null;
          return null;
        },
        onSaved: (value) => _password = value ?? '',
      ),
    );
  }

  Widget _buildHorizontalLineText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'images/horizon_line.png',
          width: 60,
          height: 30,
        ),
        SizedBox(width: 5),
        Text(
          ' Respal 아이디로 로그인 ',
          style: TextStyle(fontSize: 9, fontWeight: FontWeight.normal, color: Color(0xFF727272)),
          textAlign: TextAlign.center,
        ),
        SizedBox(width: 5),
        Image.asset(
          'images/horizon_line.png',
          width: 60,
          height: 30,
        ),
      ],
    );
  }
}
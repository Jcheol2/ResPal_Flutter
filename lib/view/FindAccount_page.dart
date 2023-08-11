import 'package:flutter/material.dart';
import 'Login_page.dart';
import '../main.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:dio/dio.dart';
import 'SignUp_page.dart';

class FindAccountPage extends StatefulWidget {
  @override
  _FindAccountPageState createState() => _FindAccountPageState();
}

class _FindAccountPageState extends State<FindAccountPage> {
  final formKey = GlobalKey<FormState>();

  String? _email;
  String? _password;

  String? _emailError = null;
  String? _passwordError = null;

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
      body: SingleChildScrollView(
        child: _buildFindAccountForm()
      ),
    );
  }

  Widget _buildFindAccountForm(){
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
            height: 60,
          ),
          SizedBox(height: 5),
          Text(
            '계정찾기',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 5),

          Text(
            '회원 가입시 입력하신 이메일 주소를 입력하시면,\n해당 이메일로 변경된 비밀번호를 보내드립니다.',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Color.fromRGBO(114, 114, 114, 1.0), // #727272
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 35),

          Text(
            '이메일 주소',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),

          SizedBox(height: 10),

          SizedBox(
            height: 40,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 0.8,
                ),
                borderRadius: BorderRadius.circular(6.5),
              ),
              child: Center(
                child: TextFormField(
                  style: TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '이메일을 입력해주세요.',
                    contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
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
              ),
            ),
          ),

          SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  child: Text(
                    '취소',
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF3B3B3B)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  child: Text(
                    '계정찾기',
                    style: TextStyle(fontSize: 12),
                  ),
                  onPressed: () {
                    validateAndSave();
                    //계정찾기 로직수행
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
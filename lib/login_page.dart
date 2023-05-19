import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  String? _email;
  String? _password;

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
        title: Text('Log in'),
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
              new ElevatedButton(
                child: new Text(
                  'Login',
                  style: new TextStyle(fontSize: 20.0),
                ),
                onPressed: validateAndSave,
              ),
              new ElevatedButton(
                child: new Text(
                  'Sign Up',
                  style: new TextStyle(fontSize: 20.0),
                ),
                onPressed: validateAndSave,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Image.asset('images/kakao.png', width: 100, height: 100),
                    onPressed: () {
                      // 카카오 로그인 버튼 클릭 시 수행할 동작
                      showToast("click kakao");
                    },
                  ),
                  IconButton(
                    icon: Image.asset('images/google.png', width: 100, height: 100),
                    onPressed: () {
                      // 구글 로그인 버튼 클릭 시 수행할 동작
                      showToast("click google");
                    },
                  ),
                  IconButton(
                    icon: Image.asset('images/github.png', width: 100, height: 100),
                    onPressed: () {
                      // 깃허브 로그인 버튼 클릭 시 수행할 동작
                      showToast("click github");
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showToast(String message){
    Fluttertoast.showToast(msg: message,
      backgroundColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM
    );
  }
}
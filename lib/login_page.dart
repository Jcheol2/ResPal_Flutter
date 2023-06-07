import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

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
                      signInKakao();
                    },
                  ),
                  IconButton(
                    icon: Image.asset('images/google.png', width: 100, height: 100),
                    onPressed: () {
                      // 구글 로그인 버튼 클릭 시 수행할 동작
                      showToast("click google");
                      signInGoogle();
                    },
                  ),
                  IconButton(
                    icon: Image.asset('images/github.png', width: 100, height: 100),
                    onPressed: () {
                      // 깃허브 로그인 버튼 클릭 시 수행할 동작
                      showToast("click github");
                      signInGithub();
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

Future<void> signInKakao() async {
  // 카카오 로그인에 필요한 파라미터 설정
  final clientId = '6dee52527ff692975e9b7b8596ad76b5';
  final redirectUri = 'http://api-respal.me/oauth/login/kakao';
  final scopes = ['email', 'profile'];

  // 카카오 로그인 URL
  final loginUrl = 'https://kauth.kakao.com/oauth/authorize?client_id=6dee52527ff692975e9b7b8596ad76b5&redirect_uri=http://api-respal.me/oauth/login/kakao&response_type=code';
  // 로그인 요청 URL 생성
  final authUrl = Uri.parse(loginUrl).replace(queryParameters: {
    'client_id': clientId,
    'redirect_uri': redirectUri,
    'response_type': 'code',
    'scope': scopes.join(' '),
  });

  // 웹뷰를 통해 카카오 로그인 페이지 열기
  final result = await FlutterWebAuth.authenticate(
    url: authUrl.toString(),
    callbackUrlScheme: redirectUri,
  );

  // 콜백 데이터 처리
  final uri = Uri.parse(result);
  final code = uri.queryParameters['code'];

  // 앱에서 받은 인증 코드를 백엔드로 전송하고 토큰을 받아올 수 있습니다.
  // 백엔드와의 통신 방식에 따라 구현하셔야 합니다.
  //sendAuthorizationCodeToBackend(code!);
  // . . .
  // 액세스 토큰 저장 및 관리 등 추가 작업을 수행합니다.
  // . . .
}

Future<void> signInGoogle() async {
  // 구글 로그인에 필요한 파라미터 설정
  final clientId = '900804701090-sk6rt9ah5cp1tmg6ppudj48ki2hs29co.apps.googleusercontent.com';
  final redirectUri = 'http://api-respal.me/oauth/app/login/google';
  final scopes = ['email', 'profile'];

  // 구글 로그인 URL
  final loginUrl = 'https://accounts.google.com/o/oauth2/auth?client_id=900804701090-sk6rt9ah5cp1tmg6ppudj48ki2hs29co.apps.googleusercontent.com&redirect_uri=http://api-respal.me/oauth/app/login/google&response_type=code&scope=https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile';
  // 로그인 요청 URL 생성
  final authUrl = Uri.parse(loginUrl).replace(queryParameters: {
    'client_id': clientId,
    'redirect_uri': redirectUri,
    'response_type': 'code',
    'scope': scopes.join(' '),
  });

  // 웹뷰를 통해 구글 로그인 페이지 열기
  final result = await FlutterWebAuth.authenticate(
    url: authUrl.toString(),
    callbackUrlScheme: 'app',
  );
  var logger = Logger();
  // 콜백 데이터 처리
  final uri = Uri.parse(result);
  final prefix = 'app://';
  final path = result.substring(prefix.length);

  String type = "";
  if (path.startsWith('signup')) {
    logger.d("신규회원");
    type = "signup";
  }else if(path.startsWith('callback')){
    logger.d("기존회원");
    type = "callback";
  }else {
    logger.d("에러");
  }

  final code = uri.queryParameters['uid'];
  logger.d(code);

  sendAuthorizationCodeToBackend(type, code!);

  // 앱에서 받은 인증 코드를 백엔드로 전송하고 토큰을 받아올 수 있습니다.
  // 백엔드와의 통신 방식에 따라 구현하셔야 합니다.

  // . . .
  // 액세스 토큰 저장 및 관리 등 추가 작업을 수행합니다.
  // . . .
}

Future<void> signInGithub() async {
  // 깃허브 로그인에 필요한 파라미터 설정
  final clientId = 'Iv1.dbc970eb37f92943';
  final redirectUri = 'http://api-respal.me/oauth/login/github';
  final scopes = ['email', 'profile'];

  // 깃허브 로그인 URL
  final loginUrl = 'https://github.com/login/oauth/authorize?client_id=Iv1.dbc970eb37f92943'
      '&redirect_uri=http://api-respal.me/oauth/login/github';
  // 로그인 요청 URL 생성
  final authUrl = Uri.parse(loginUrl).replace(queryParameters: {
    'client_id': clientId,
    'redirect_uri': redirectUri,
    'response_type': 'code',
    'scope': scopes.join(' '),
  });

  // 웹뷰를 통해 깃허브 로그인 페이지 열기
  final result = await FlutterWebAuth.authenticate(
    url: authUrl.toString(),
    callbackUrlScheme: redirectUri,
  );

  // 콜백 데이터 처리
  final uri = Uri.parse(result);
  final code = uri.queryParameters['code'];

  // 앱에서 받은 인증 코드를 백엔드로 전송하고 토큰을 받아올 수 있습니다.
  // 백엔드와의 통신 방식에 따라 구현하셔야 합니다.

  // . . .
  // 액세스 토큰 저장 및 관리 등 추가 작업을 수행합니다.
  // . . .
}

Future<void> sendAuthorizationCodeToBackend(String type, String code) async {
  final dio = Dio(); // Dio 인스턴스 생성
  try {
    dio.get('http://api-respal.me/oauth/user/uid=' + code + '?type='+type);
    var logger = Logger();
    logger.d(dio.toString());
  }catch(e){
    print('Exception occurred: $e');
  }

    // final response = await dio.post(
    //   'http://api-respal.me/oauth/user/'+code, // 백엔드 API 엔드포인트 URL
    //   data: {
    //     'code': code, // 인증 코드 전송
    //   },
    // );

    // 응답 처리
  //   if (response.statusCode == 200) {
  //     // 토큰을 성공적으로 받아온 경우
  //     final token = response.data;
  //     // 받아온 토큰을 앱에서 저장하거나 관리하는 로직을 구현합니다.
  //     // ...
  //   } else {
  //     // 오류가 발생한 경우
  //     print('Error: ${response.statusCode}');
  //     // 오류 처리 로직을 구현합니다.
  //     // ...
  //   }
  // } catch (e) {
  //   // 네트워크 요청 실패 등 예외가 발생한 경우
  //   print('Exception occurred: $e');
  //   // 예외 처리 로직을 구현합니다.
  //   // ...
  // }
}
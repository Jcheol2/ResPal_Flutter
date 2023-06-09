import 'package:flutter/material.dart';
import 'main.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:dio/dio.dart';
import 'main_page.dart';
import 'signup_page.dart';

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
                onPressed:(){
                  validateAndSave;
                sendCommonToBackend(context, _email!, _password!);
                }
              ),
              ElevatedButton(
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Image.asset('images/kakao.png', width: 100, height: 100),
                    onPressed: () {
                      signInOauth(context, "kakao");
                    },
                  ),
                  IconButton(
                    icon: Image.asset('images/google.png', width: 100, height: 100),
                    onPressed: () {
                      signInOauth(context, "google");
                    },
                  ),
                  IconButton(
                    icon: Image.asset('images/github.png', width: 100, height: 100),
                    onPressed: () {
                      signInOauth(context, "github");
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
}

Future<void> signInOauth(BuildContext context, String platform) async {
  // 로그인에 필요한 파라미터 설정
  var clientId;
  var redirectUri;
  var loginUrl;
  var scopes = ['', ''] ;
  final urlScheme = "app";
  var type = "";

  if(platform.contains("kakao")){
    clientId = '6dee52527ff692975e9b7b8596ad76b5';
    redirectUri = 'http://api-respal.me/oauth/app/login/kakao';
    loginUrl = 'https://kauth.kakao.com/oauth/authorize?'
        'client_id=6dee52527ff692975e9b7b8596ad76b5&redirect_uri=http://api-respal.me/oauth/app/login/kakao&response_type=code';
  }else if(platform.contains("google")){
    clientId = '900804701090-sk6rt9ah5cp1tmg6ppudj48ki2hs29co.apps.googleusercontent.com';
    redirectUri = 'http://api-respal.me/oauth/app/login/google';
    loginUrl = 'https://accounts.google.com/o/oauth2/auth?'
        'client_id=900804701090-sk6rt9ah5cp1tmg6ppudj48ki2hs29co.apps.googleusercontent.com&redirect_uri=http://api-respal.me/oauth/app/login/google&response_type=code&scope=https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile';
    scopes = ['email', 'profile'];
  }else if(platform.contains("github")){
    clientId = 'Iv1.dbc970eb37f92943';
    redirectUri = 'http://api-respal.me/oauth/app/login/github';
    loginUrl = 'https://github.com/login/oauth/authorize?'
        'client_id=Iv1.dbc970eb37f92943&redirect_uri=http://api-respal.me/oauth/app/login/github';
  }else{
    return;
  }

  // 로그인 요청 URL 생성
  final authUrl = Uri.parse(loginUrl).replace(queryParameters: {
    'client_id': clientId,
    'redirect_uri': redirectUri,
    'response_type': 'code',
    'scope': scopes.join(' '),
  });

  // 웹뷰를 통해 로그인 페이지 열기
  final result = await FlutterWebAuth.authenticate(
    url: authUrl.toString(),
    callbackUrlScheme: urlScheme,
  );

  // 콜백 데이터 처리
  final uri = Uri.parse(result);
  final prefix = 'app://';
  final path = result.substring(prefix.length);
  final code = uri.queryParameters['uid'];

  if (path.startsWith('signup')) {
    type = "signup";
  }else if(path.startsWith('callback')){
    type = "callback";
  }else {
    print("에러");
    return;
  }

  sendOauthToBackend(context, type, code!);
}
Future<void> sendCommonToBackend(BuildContext context, String email, String password) async {
  final dio = Dio(); // Dio 인스턴스 생성
  final response = await dio.post(
    'http://api-respal.me/member/login', // 백엔드 API 엔드포인트 URL
    data: {
      "email": email, // required
      "password": password, // 일반회원은 필수, oauth는 null
    },
  );

  // 응답 처리
  if (response.statusCode == 200) {
    // 토큰을 성공적으로 받아온 경우
    final jsondata = response.data;

    final accessToken = jsondata['data']['accessToken'];
    final refreshToken = jsondata['data']['refreshToken'];
    logger(accessToken);
    logger(refreshToken);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
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

// 앱에서 받은 인증 코드를 백엔드로 전송
// 액세스 토큰 저장 및 관리 등 추가 작업을 수행합니다.
Future<void> sendOauthToBackend(BuildContext context, String type, String code) async {
  final dio = Dio(); // Dio 인스턴스 생성

  logger(code);
  logger(type);
  try {
    final response = await dio.get(
      'http://api-respal.me/oauth/user/' + code + '?type=' + type, // 백엔드 API 엔드포인트 URL
    );

    logger(response);
    logger(response.statusCode);
    logger(response.data);

    // 응답 처리
    if (response.statusCode == 200) {
      // 토큰을 성공적으로 받아온 경우
      final jsondata = response.data;
      if(type.contains("signup")){
        SignUpOauth(context, jsondata);
      }else if(type.contains("callback")){
        //토큰 내부에 저장 및 메인페이지로 전송
        final accessToken = jsondata['data']['accessToken'];
        final refreshToken = jsondata['data']['refreshToken'];
        logger(accessToken);
        logger(refreshToken);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      }

      // 받아온 토큰을 앱에서 저장하거나 관리하는 로직을 구현합니다.
      // sharedpreference로 저장
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

Future<void> SignUpOauth(BuildContext context, dynamic jsondata) async {
  final dio = Dio(); // Dio 인스턴스 생성
  try {
    final userInfo = jsondata['data']['userInfo'];
    final email = userInfo['email'];
    final image = userInfo['image'];
    final nickname = userInfo['nickname'];
    final provider = jsondata['data']['provider'];

    final response = await dio.post(
      'http://api-respal.me/member/join', // 백엔드 API 엔드포인트 URL
      data: {
        "email": email, // required
        "password": null, // 일반회원은 필수, oauth는 null
        "picture": image, // oauth login시 받은 image 자동 세팅
        "nickname": nickname,
        "provider": provider // required
      },
    );

    logger(response);
    logger(response.statusCode);
    logger(response.data);

    // 응답 처리
    if (response.statusCode == 201) {
      final accessToken = jsondata['data']['accessToken'];
      final refreshToken = jsondata['data']['refreshToken'];
      final membersEmail = jsondata['data']['membersEmail'];
      logger(accessToken);
      logger(refreshToken);
      logger(membersEmail);

      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
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
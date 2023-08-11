import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import '../../../view/Login_page.dart';
import '../../../main.dart';
import '../../../view/Main_page.dart';


class RetrofitConfig {
  // Future<List<Album>> getAlbumList() async {
  //   final dio = Dio();
  //
  //   final response = await dio.get(
  //     'http://api-respal.me/oauth/user/' + code + '?type=' + type, // 백엔드 API 엔드포인트 URL
  //   );
  //   return jsonDecode(response.body)
  //       .map<Album>((json) => Album.fromJson(json))
  //       .toList();
  // }



  Future<void> signInOauth(BuildContext context, String platform) async {
    // 로그인에 필요한 파라미터 설정
    var clientId;
    var redirectUri;
    var loginUrl;
    var scopes = ['', ''];
    final urlScheme = "app";
    var type = "";

    if (platform.contains("kakao")) {
      clientId = '6dee52527ff692975e9b7b8596ad76b5';
      redirectUri = 'http://api-respal.me/oauth/app/login/kakao';
      loginUrl = 'https://kauth.kakao.com/oauth/authorize?'
          'client_id=6dee52527ff692975e9b7b8596ad76b5&redirect_uri=http://api-respal.me/oauth/app/login/kakao&response_type=code';
    } else if (platform.contains("google")) {
      clientId =
      '900804701090-sk6rt9ah5cp1tmg6ppudj48ki2hs29co.apps.googleusercontent.com';
      redirectUri = 'http://api-respal.me/oauth/app/login/google';
      loginUrl = 'https://accounts.google.com/o/oauth2/auth?'
          'client_id=900804701090-sk6rt9ah5cp1tmg6ppudj48ki2hs29co.apps.googleusercontent.com&redirect_uri=http://api-respal.me/oauth/app/login/google&response_type=code&scope=https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile';
      scopes = ['email', 'profile'];
    } else if (platform.contains("github")) {
      clientId = 'Iv1.dbc970eb37f92943';
      redirectUri = 'http://api-respal.me/oauth/app/login/github';
      loginUrl = 'https://github.com/login/oauth/authorize?'
          'client_id=Iv1.dbc970eb37f92943&redirect_uri=http://api-respal.me/oauth/app/login/github';
    } else {
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
    } else if (path.startsWith('callback')) {
      type = "callback";
    } else {
      print("에러");
      return;
    }

    sendOauthToBackend(context, type, code!);
  }

  Future<void> sendCommonToBackend(BuildContext context, String email,
      String password) async {
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
          MaterialPageRoute(
              builder: (context) => MainPage(refreshToken)
          )
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
  Future<void> sendAuthenticatedRequest(BuildContext context,
      String refreshToken, String accessToken, String type) async {
    final dio = Dio();

    try {
      final response = await dio.get(
        'http://api-respal.me/test',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        if (type.contains("login")) {
          showToast("로그인 되었습니다");
        } else {
          showToast("회원가입 되었습니다");
        }

        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainPage(refreshToken)),
        );
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // 오류 처리
      print('Exception occurred: $e');
    }
  }

  Future<void> sendOauthToBackend(BuildContext context, String type,
      String code) async {
    final dio = Dio();

    logger(code);
    logger(type);
    try {
      final response = await dio.get(
        'http://api-respal.me/oauth/user/' + code + '?type=' + type,
      );

      logger(response);
      logger(response.statusCode);
      logger(response.data);

      if (response.statusCode == 200) {
        final jsondata = response.data;
        if (type.contains("signup")) {
          SignUpOauth(context, jsondata);
        } else if (type.contains("callback")) {
          final accessToken = jsondata['data']['accessToken'];
          final refreshToken = jsondata['data']['refreshToken'];
          logger(accessToken);
          logger(refreshToken);

          // 새로운 요청을 보냄
          await sendAuthenticatedRequest(
              context, refreshToken, accessToken, "login");
        }

        // 토큰을 앱에서 저장하거나 관리하는 로직을 구현합니다.
      } else {
        print('Error: ${response.statusCode}');
        // 오류 처리 로직을 구현합니다.
        // ...
      }
    } catch (e) {
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

      jsondata = response.data;
      // 응답 처리
      if (response.statusCode == 201) {
        final accessToken = jsondata['data']['accessToken'];
        final refreshToken = jsondata['data']['refreshToken'];
        final membersEmail = jsondata['data']['membersEmail'];
        logger(accessToken);
        logger(refreshToken);
        logger(membersEmail);

        await sendAuthenticatedRequest(
            context, refreshToken, accessToken, "signup");
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
}
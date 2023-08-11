import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../model/User.dart';

part 'RetrofitApi.g.dart'; // 코드 생성을 위한 파일 경로

//Terminal - flutter pub run build_runner build
@RestApi(baseUrl: "http://api-respal.me/")
abstract class RetrofitApi {
  factory RetrofitApi(Dio dio, {String baseUrl}) = _RetrofitApi;

  @GET("member/login")
  Future<Response> sendCommonToBackend(
      @Query("email") String email,
      @Query("password") String password,
      );

  @GET("test")
  Future<Response> sendAuthenticatedRequest(
      @Header("Authorization") String accessToken,
      );

  @GET("oauth/user/{code}")
  Future<Response> sendOauthToBackend(
      @Path("code") String code,
      @Query("type") String type,
      );

  @POST("member/join")
  Future<Response> SignUpOauth(
      @Field("email") String email,
      @Field("password") String password,
      @Field("picture") String picture,
      @Field("nickname") String nickname,
      @Field("provider") String provider,
      );

  @POST("member/join")
  Future<Response> SignupToCommon(
      @Field("email") String email,
      @Field("password") String password,
      @Field("picture") String picture,
      @Field("nickname") String nickname,
      @Field("provider") String provider,
      );

  @POST("member/logout")
  Future<Response> Logout(
      @Header("Authorization") String refreshToken,
      );
}
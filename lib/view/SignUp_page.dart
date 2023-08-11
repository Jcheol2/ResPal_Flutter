import 'package:flutter/material.dart';
import 'Login_page.dart';
import '../main.dart';
import 'package:dio/dio.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();

  String? _email;
  String? _vEmail;
  String? _password;
  String? _job;
  String? _nickname;

  String? _selectedJob;

  List<String> jobOptions = [
    '프론트엔드 개발자',
    '백엔드 개발자',
    '모바일 앱 개발자',
    '데이터 엔지니어',
    // Add other job options here
  ];

  String? _emailError;
  String? _vEmailError;
  String? _passwordError;
  String? _jobError;
  String? _nicknameError;

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
        child: _buildSignupForm()
      ),
    );
  }

  Widget _buildSignupForm() {
    return  Container(
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

          SizedBox(height: 10),

          Text(
            'Respal에 오신 것을 환영합니다.',
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
            'SNS 회원가입',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          Row(
            children: [
              Expanded(
                child: IconButton(
                  icon: Image.asset('images/github.png'),
                  onPressed: () {
                    // signInOauth(context, "github");
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Image.asset('images/google.png'),
                  onPressed: () {
                    // signInOauth(context, "google");
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Image.asset('images/kakao.png'),
                  onPressed: () {
                    // signInOauth(context, "kakao");
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 10),

          _buildHorizontalLineText(),

          SizedBox(height: 10),

          Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildFormField('Email', '4~15자 이내로 입력해주세요.', _email, (value) {
                  if (value?.isEmpty ?? true) {
                    _emailError = 'Email can\'t be empty';
                    return null;
                  }
                  _emailError = null;
                  return null;
                }),

                if (_emailError != null)
                  _buildFormErrorText(_emailError!),

                _buildFormField('PassWord', '최소 6자 이상(알파벳, 숫자 필수).', _password, (value) {
                  if (value?.isEmpty ?? true) {
                    _passwordError = 'Password can\'t be empty';
                    return null;
                  }
                  _passwordError = null;
                  return null;
                }),

                if (_passwordError != null)
                  _buildFormErrorText(_passwordError!),

                _buildFormField('Verification Email', 'koreanwizard@respal.kr', _vEmail, (value) {
                  if (value?.isEmpty ?? true) {
                    _vEmailError = 'Verification Email can\'t be empty';
                    return null;
                  }
                  _vEmailError = null;
                  return null;
                }),

                if (_vEmailError != null)
                  _buildFormErrorText(_vEmailError!),

                _buildFormField('Job', '', _selectedJob, (value) {
                  if (value == null || value.isEmpty) {
                    _jobError = 'Job can\'t be empty';
                    return null;
                  }
                  _jobError = null;
                  return null;
                }, dropDownFormField: true),

                if (_jobError != null)
                  _buildFormErrorText(_jobError!),

                _buildFormField('NickName', '별명을 알파벳, 한글, 숫자를 20자 이하로 입력해주세요.', _nickname, (value) {
                  if (value?.isEmpty ?? true) {
                    _nicknameError = 'NickName can\'t be empty';
                    return null;
                  }
                  _nicknameError = null;
                  return null;
                }),

                if (_nicknameError != null)
                  _buildFormErrorText(_nicknameError!),

                SizedBox(height: 10),

                _buildTermsText('서비스 이용 약관', () {
                  // Navigate to service terms page
                }),

                _buildTermsText('개인정보 처리방침', () {
                  // Navigate to privacy policy page
                }),

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
                    '회원가입',
                    style: TextStyle(fontSize: 12),
                  ),
                  onPressed: () {
                    validateAndSave();
                  },
                ),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '이미 회원이신가요?',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                        textAlign: TextAlign.left,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                        ),
                        child: Text(
                          "로그인",
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
  Widget _buildFormField(String label, String hint, String? value, FormFieldValidator<String?> validator,
      {bool dropDownFormField = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 10),
        Container(
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
          child: dropDownFormField
              ? _buildDropDownFormField(value, hint, validator)
              : TextFormField(
            style: TextStyle(fontSize: 12),
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
            ),
            validator: validator,
            onSaved: (value) => value,
          ),
        ),
      ],
    );
  }

  Widget _buildDropDownFormField(
      String? value, String hint, FormFieldValidator<String?> validator) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.copyWith(
          subtitle1: TextStyle(fontSize: 12),
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        items: jobOptions.map((String job) {
          return DropdownMenuItem<String>(
            value: job,
            child: Text(job),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedJob = newValue;
          });
        },
        style: TextStyle(fontSize: 12),
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
        ),
        validator: validator,
        onSaved: (value) => value,
      ),
    );
  }

  Widget _buildFormErrorText(String error) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Visibility(
        visible: error.isNotEmpty,
        child: Text(
          error,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget _buildTermsText(String text, VoidCallback onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.deepPurpleAccent,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 3),
        Image.asset(
          'images/vertical_line.png',
          height: 15,
          width: 1,
        ),
        SizedBox(width: 3),
      ],
    );
  }

  Widget _buildHorizontalLineText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'images/horizon_line.png',
          height: 30,
          width: 90,
        ),
        SizedBox(width: 5),
        Text(
          ' 회원가입에 필요한 기본정보를 입력해주세요. ',
          style: TextStyle(fontSize: 9, fontWeight: FontWeight.normal, color: Color(0xFF727272)),
          textAlign: TextAlign.center,
        ),
        SizedBox(width: 5),
        Image.asset(
          'images/horizon_line.png',
          height: 30,
          width: 90,
        ),
      ],
    );
  }
}

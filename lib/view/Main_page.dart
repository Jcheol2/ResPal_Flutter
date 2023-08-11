import 'dart:math';

import 'package:flutter/material.dart';
import 'package:respal/view/Login_page.dart';
import '../data/remote/api/RetrofitConfig.dart';
import '../main.dart';
import 'package:dio/dio.dart';

class MainPage extends StatefulWidget {
  final String refreshToken;
  const MainPage(this.refreshToken);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final formKey = GlobalKey<FormState>();
  RetrofitConfig retrofitConfig = new RetrofitConfig();

  String refreshToken = "";

  @override
  void initState() {
    super.initState();
    refreshToken = widget.refreshToken;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main'),
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
                decoration: new InputDecoration(labelText: 'Text'),
              ),
              new ElevatedButton(
                  child: new Text(
                    'Logout',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  onPressed:(){
                    retrofitConfig.Logout(context, refreshToken);
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
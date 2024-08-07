import 'dart:async';

import 'package:flutter/material.dart';
import 'package:post_api/api_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  dynamic userDetails;
  bool isLoading = false;

  getUserDetails () {
    setState(() {
      isLoading = true;
    });
    ApiServices().getUserDetails().then((value) {
      print('userDetails ==> ${value.toString()}');
      setState(() {
        userDetails = value;
        isLoading = false;
      });
    },);

  }

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child:
          isLoading == true ? CircularProgressIndicator():
          Text(userDetails['name'].toString()),

        ),
      ),
    );
  }
}

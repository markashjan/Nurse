import 'package:flutter/material.dart';
import 'package:nurse/appointment.dart';
import 'package:nurse/healthrecord.dart';
import 'package:nurse/loginpage.dart';
import 'package:nurse/nursemainpage.dart';
import 'package:nurse/pharmacy.dart';
void main()=> runApp(const MyApp());

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Start Up Page",
      home: startuppage(),
      routes: {
        'loginpage' : (context) => loginpage(),
        'nursemainpage' : (context) => nursemainpage(),
        'healthrecord' : (context) => HealthRecordsPage(),
        'appointment' : (context) => Appointment(),
        'pharmacy' : (context) => Pharmacy(),
      },
    );
  }
}

class startuppage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(
          child: Text("Welcome to Health First : A Clinic Management Mobile Application",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          ),
        ),
        const SizedBox(height: 100.0),
        ElevatedButton(
            onPressed:() => Navigator.pushNamed(context, 'loginpage'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,backgroundColor: Colors.blue,
            ),
            child: const Text('Login'),
        ),
        const SizedBox(height: 20.0),
        ElevatedButton(onPressed: ()=> Navigator.pushNamed(context, 'nursemainpage'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,backgroundColor: Colors.blue,
            ),
            child: const Text('Main Page'),
        ),
        const SizedBox(height: 20.0),
      ],

    ),
    ),
    );
    }
  }

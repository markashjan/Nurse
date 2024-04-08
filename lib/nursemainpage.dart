import 'package:flutter/material.dart';

class nursemainpage extends StatelessWidget {
  const nursemainpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50.0,
                  child: Icon(Icons.account_circle,size:100,color: Colors.white,),
                  //backgroundImage: AssetImage('assets/profile_picture.png'), // Replace with your image path
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Nurse',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),

                      ),
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, 'healthrecord'),
                        child: Row(
                          children: [
                            Icon(Icons.medication, color: Colors.white),
                            SizedBox(width: 8.0),
                            Text('Health Record', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),

                      ),
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, 'appointment'),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.white),
                            SizedBox(width: 8.0),
                            Text('Appointments', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 130.0, vertical: 2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, 'pharmacy'),
                    child: Row(
                      children: [
                        Icon(Icons.medication_liquid, color: Colors.white),
                        SizedBox(width: 8.0),
                        Text('Pharmacy', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ]
          )
      ),
    );
  }
}

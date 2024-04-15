import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;
import 'dart:convert';
import 'package:nurse/nursemainpage.dart';

class loginpage extends StatefulWidget{
  const loginpage({Key? key}) : super(key: key);

  @override
  State<loginpage> createState()=> _loginpageState();
}
class _loginpageState extends State<loginpage>{
  final _formKey = GlobalKey<FormState>();
  String _id = "";
  String _pass = "";

  Future<String>_login(String id, String pass) async{

    final response = await http.post(
      Uri.parse('http://127.0.0.1/Mysql/nurseloginscript.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id, 'pass': pass}),
    );
    if (response.statusCode == 200) {
      // Parse the JSON response to handle successful login
      final data = jsonDecode(response.body);
      if (data['success']) {
        // Store the token securely (e.g., using a secure storage library)
        // and navigate to the main page
        return data['token'];
      } else {
        return data['error']; // Handle login error
      }
    } else {
      // Handle API request error
      return 'Error: ${response.statusCode}';
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          title: Text('Login',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),),
          leading: BackButton(
            onPressed: ()=> Navigator.of(context).pop(),
          )
      ),
      body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(50.0),
            child: Form(
              key: _formKey,
              child:Column(
                children: [
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'ID',
                    border: OutlineInputBorder()
                  ),
                  validator: (value){
                    if (value == null || value.isEmpty){
                      return 'Please enter your ID';
                    }
                    return null;
                  },
                  onSaved: (newValue)=> _id = newValue!,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Password',
                    border: OutlineInputBorder()
                  ),
                  validator: (value){
                    if (value == null || value.isEmpty){
                      return 'Please enter your Password';
                    }
                    return null;
                  },
                  onSaved: (newValue)=> _pass = newValue!,
                ),
                SizedBox(height: 10.0),
                ElevatedButton(onPressed: () async{
                  if(_formKey.currentState!.validate()){
                    _formKey.currentState!.save();
                    final result = await _login(_id, _pass);
                    if (result.isNotEmpty && !result.startsWith('Error')){
                      print ('Login Successfully');

                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const nursemainpage()));
                  
                    }else{
                      print('Login Failed');
                    }
                  }
                }, child: Text('Login'))
              ],
            ),
            )

          )
      ),
    );
  }

}
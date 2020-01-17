import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:async';
import 'AddData.dart';
import 'Detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
 runApp(MaterialApp(
   home: Login(),
   theme: ThemeData(),
    debugShowCheckedModeBanner: false,
 ));
}

class Login extends StatefulWidget {
 @override
 _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginState extends State<Login> {
 LoginStatus _loginStatus = LoginStatus.notSignIn;
 String email, password;
 final _key = new GlobalKey<FormState>();

 bool _secureText = true;

 showHide() {
   setState(() {
     _secureText = !_secureText;
   });
 }

 check() {
   final form = _key.currentState;
   if (form.validate()) {
     form.save();
     login();
   }
 }

 login() async {
   final response = await http.post("http://192.168.42.22/ /login.php",
       body: {"email": email, "password": password});
   final data = jsonDecode(response.body);
   int value = data['value'];
   String pesan = data['message'];
   String emailAPI = data['email'];
   String namaAPI = data['nama'];
   String id = data['id'];
   if (value == 1) {
     setState(() {
       _loginStatus = LoginStatus.signIn;
       savePref(value, emailAPI, namaAPI, id);
     });
     print(pesan);
   } else {
     print(pesan);
   }
 }

 savePref(int value, String email,String nama, String id) async {
   SharedPreferences preferences = await SharedPreferences.getInstance();
   setState(() {
     preferences.setInt("value", value);
     preferences.setString("nama", email);
     preferences.setString("email", email);
     preferences.setString("id", id);
     
   });
 }

 var value;
 getPref() async {
   SharedPreferences preferences = await SharedPreferences.getInstance();
   setState(() {
     value = preferences.getInt("value");

     _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
   });
 }

 signOut() async {
   SharedPreferences preferences = await SharedPreferences.getInstance();
   setState(() {
     preferences.setInt("value", null);
     _loginStatus = LoginStatus.notSignIn;
   });
 }

 @override
 void initState() {

   super.initState();
   getPref();
 }

 @override
 Widget build(BuildContext context) {
   switch (_loginStatus) {
     case LoginStatus.notSignIn:
       return Scaffold(
         appBar: AppBar(
           title: Text("Login"),
         ),
         body: Form(
           key: _key,
           child: ListView(
             padding: EdgeInsets.all(16.0),
             children: <Widget>[
               TextFormField(
                 validator: (e) {
                   if (e.isEmpty) {
                     return "Please insert email";
                   }
                 },
                 onSaved: (e) => email = e,
                 decoration: InputDecoration(
                   labelText: "email",
                 ),
               ),
               
               TextFormField(
                 obscureText: _secureText,
                 onSaved: (e) => password = e,
                 decoration: InputDecoration(
                   labelText: "Password",
                   suffixIcon: IconButton(
                     onPressed: showHide,
                     icon: Icon(_secureText
                         ? Icons.visibility_off
                         : Icons.visibility),
                   ),
                 ),
               ),
               MaterialButton(
                 onPressed: () {
                   check();
                 },
                 child: Text("Login"),
               ),
               
             ],
           ),
         ),
       );
       break;
     case LoginStatus.signIn:
       return MainMenu(signOut);
       break;
   }
 }
}


// class _RegisterState extends State<Register> {

class MainMenu extends StatefulWidget {
 final VoidCallback signOut;
 MainMenu(this.signOut);
 @override
 _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
 signOut() {
   setState(() {
     widget.signOut();
   });
 }

//  String email = "", nama = "";
//  TabController tabController;

 getPref() async {
   SharedPreferences preferences = await SharedPreferences.getInstance();
   setState(() {
//      email = preferences.getString("email");
//      nama = preferences.getString("nama");
   });
 }

 @override
 void initState() {
 
   super.initState();
   getPref();
 }

 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: new AppBar(
          title: Text("Data Pegawai"),
          backgroundColor: Colors.green,
        ),
        floatingActionButton: new FloatingActionButton(
          child: new Icon(
            Icons.add,
            color: Colors.green,
          ),
          onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) => new AddData(),
          )),
        ),
        body: new FutureBuilder<List>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? new ItemList(
                    list: snapshot.data,
                  )
                : new Center(
                    child: new CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }

  getData() {}
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({this.list});
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          return new Container(
            child: new GestureDetector(
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Detail(
                        list: list,
                        index: i,
                      ))),
              child: new Card(
                color: Colors.white,
                child: new ListTile(
                  title: new Text(list[i]['nama']),
                  leading: new Icon(Icons.list),
                  subtitle: new Text("Posisi : ${list[i]['posisi']}"),
                ),
              ),
            ),
          );
        });
  }
}
 
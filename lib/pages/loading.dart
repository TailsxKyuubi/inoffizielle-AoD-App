import 'package:flutter/material.dart';
import '../caches/login.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
          onWillPop: () async => false,
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color.fromRGBO(53, 54, 56, 1),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1),
                ),
                Image.asset('images/logo.png',scale: 3,),
                Flexible(child: Container()),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    loginDataChecked?'Animeliste wird geladen':'Anmeldedaten werden überprüft',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SpinKitThreeBounce(
                  color: Theme.of(context).accentColor,
                  size: 40
                )
              ],
            )
        ),
        ),
    );
  }

}
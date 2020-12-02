import 'package:flutter/material.dart';
import '../caches/login.dart';
class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color.fromRGBO(53, 54, 56, 1),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1),
                ),
                Image.asset('images/fast.gif',scale: 5,),
                Flexible(child: Container()),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    loginDataChecked?'Animeliste wird geladen':'Anmeldedaten werden überprüft',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )

              ],
            )
        )
    );
  }

}
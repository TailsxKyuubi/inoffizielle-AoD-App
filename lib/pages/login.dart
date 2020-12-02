import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/caches/login.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope (
            onWillPop: () async => false,
            child: Container(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Form(
                autovalidate: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Anmeldung',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    TextFormField(
                        controller: this._usernameController,
                        decoration: const InputDecoration(
                          hintText: 'Gib deinen Benutzernamen ein',
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Gib deinen Benutzernamen ein';
                          }
                          return null;
                        }
                    ),
                    Padding(padding: EdgeInsets.all(20)),
                    TextFormField(
                        controller: this._passwordController,
                        decoration: const InputDecoration(
                          hintText: 'Gib dein Passwort ein',
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Gib deine Passwort ein';
                          }
                          return null;
                        }
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    RaisedButton(
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false
                        // otherwise.
                        // If the form is valid, display a Snackbar.
                        if(this._passwordController.text.isNotEmpty && this._usernameController.text.isNotEmpty){

                          //loginSuccess = true;
                          saveCredentials(this._usernameController.text, this._passwordController.text);
                          loginDataChecked = false;
                          Navigator.pushReplacementNamed(context, '/base');
                        }else{
                          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Bitte überprüfe deine Eingaben')));
                        }
                        //}
                      },
                      child: Text('Anmelden'),
                    ),
                  ],
                ),
              ),
            )
        )
    );
  }
}

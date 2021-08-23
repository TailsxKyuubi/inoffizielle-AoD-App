/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/caches/login.dart' as loginCache;

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  FocusNode username = FocusNode();
  FocusNode password = FocusNode();

  @override
  void initState(){
    super.initState();
    this.username = FocusNode();
    this.password = FocusNode();
  }

  void login(){
    loginCache.saveCredentials(this._usernameController.text, this._passwordController.text);
    loginCache.loginStorageChecked = false;
    loginCache.loginDataChecked = false;
    loginCache.loginSuccess = false;
    Navigator.pushReplacementNamed(context, '/base');
  }

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color.fromRGBO(171, 191, 57, 1);
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor
      ),
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: Form(
        child: AutofillGroup(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Anmeldung',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor
                ),
              ),
              loginCache.loginDataChecked && ! loginCache.loginSuccess
                  ? Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    'Deine Anmeldedaten stimmen nicht',
                    style: TextStyle(
                        color: Colors.red
                    ),
                  )
              )
                  : Container(),
              Padding(padding: EdgeInsets.all(10)),
              TextFormField(
                focusNode: this.username,
                controller: this._usernameController,
                autofillHints: [
                  AutofillHints.email,
                  AutofillHints.username
                ],
                decoration: const InputDecoration(
                    hintText: 'Gib deinen Benutzernamen ein',
                    fillColor: Colors.white,
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white
                        )
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: accentColor
                        )
                    )
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Gib deinen Benutzernamen ein';
                  }
                  return null;
                },
                autofocus: true,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value){
                  username.unfocus();
                  FocusScope.of(context).requestFocus(password);
                },
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Padding(padding: EdgeInsets.all(20)),
              TextFormField(
                focusNode: this.password,
                controller: this._passwordController,
                autofillHints: [
                  AutofillHints.password
                ],
                decoration: const InputDecoration(
                    hintText: 'Gib dein Passwort ein',
                    fillColor: Colors.white,
                    hintStyle: TextStyle(
                        color: Colors.white
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white
                        )
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: accentColor
                        )
                    )
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Gib deine Passwort ein';
                  }
                  return null;
                },
                onFieldSubmitted:(value){
                  this.password.unfocus();
                  if(this._passwordController.text.isNotEmpty && this._usernameController.text.isNotEmpty){
                    login();
                  }else{
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Bitte überprüfe deine Eingaben')));
                  }
                },
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
              RaisedButton(
                color: accentColor,
                onPressed: () async {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  // If the form is valid, display a Snackbar.
                  if(this._passwordController.text.isNotEmpty && this._usernameController.text.isNotEmpty){
                    login();
                  }else{
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Bitte überprüfe deine Eingaben')));
                  }
                  //}
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 80,
                  child: Text(
                    'Anmelden',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose(){
    username.dispose();
    password.dispose();
    super.dispose();
  }
}

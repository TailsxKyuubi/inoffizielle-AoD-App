import 'package:flutter/material.dart';

class UpdatesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Updates'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(
          top: 20,
          bottom: 20,
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              child: Text(
                'Du verwendest die Version 0.7.1-1.0-tvalpha der App',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Text(
                'Die aktuellen Versionen zur App gibts unter https://github.com/TailsxKyuubi/inoffizielle-AoD-App',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Text(
                'Aktuelle News zur App gibts unter https://twitter.com/TailsxKyuubi',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}
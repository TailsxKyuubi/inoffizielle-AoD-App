import 'package:flutter/material.dart';

class HistoryWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HistoryWidgetState();
}
class _HistoryWidgetState extends State<HistoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor
      ),
    );
  }

}
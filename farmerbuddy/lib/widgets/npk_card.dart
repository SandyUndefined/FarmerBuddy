import 'package:flutter/material.dart';

class NPKCard extends StatelessWidget {
  final String title;
  final double value;

  NPKCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text("Value: $value mg/kg"),
      ),
    );
  }
}

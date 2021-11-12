import 'package:flutter/material.dart';

class DitontonErrorWidget extends StatelessWidget {
  final String message;
  final Function? retry;

  DitontonErrorWidget(this.message, {this.retry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Text(message),
            if (retry != null) ElevatedButton(onPressed: () {
              retry?.call();
            }, child: Text('Retry'))
          ],
      ),
    );
  }
  
}
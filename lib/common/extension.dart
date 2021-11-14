import 'package:flutter/material.dart';

extension Dialog on BuildContext {
  Future<void> dialog(String message, Function retry) async {
    await showDialog(
        context: this,
        builder: (context) => AlertDialog(
              content: Text(message),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      retry();
                    },
                    child: Text('Retry'))
              ],
            ));
  }
}

import 'package:flutter/material.dart';
import 'package:my_dentist/our_widgets/settings.dart';

class LoadingDialog {
  LoadingDialog();

  static Future<void> showLoadingDialog(
    BuildContext context, {
    String msg = 'Loading...',
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent user from dismissing the dialog
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: OurSettings.mainColors[100],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 10.0),
                  Text(msg),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    Navigator.pop(context);
  }
}

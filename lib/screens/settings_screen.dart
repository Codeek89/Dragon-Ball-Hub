import 'package:dragonballhub/providers/top_level_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  static const String id = "/settings_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(child: Container()),
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: (){
                  final user = context.read(loginProvider);
                  user.signOut();
                  user.userAuth.resetData();
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:to_do_app/ui/pages/notification_screen.dart';

import 'ui/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: Colors.teal,
        backgroundColor: Colors.teal
      ),
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: NotificationScreen(payload: 'Title text ||Description ||Date'),
    );
  }
}

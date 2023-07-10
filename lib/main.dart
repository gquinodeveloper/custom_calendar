import 'package:custom_calendar/views/custom_calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      //ignore: always_specify_types
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        SfGlobalLocalizations.delegate
      ],
      //ignore: always_specify_types
      supportedLocales: const [
        Locale('es', 'ES'),
        //Locale('ar', 'AE'),
      ],
      locale: const Locale('es', 'ES'),
      home: const CustomCalendarView(),
    );
  }
}

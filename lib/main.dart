import 'dart:async';
import 'dart:ui';

import 'package:background_service_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  runApp(const App());
}

Future<void> initializeApp() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');
  return true;
}

void onStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();
  // if (service is AndroidServiceInstance) {
  //   service.on('setAsForeground').listen((event) {
  //     service.setAsForegroundService();
  //   });
  //
  //   service.on('setAsBackground').listen((event) {
  //     service.setAsBackgroundService();
  //   });
  //
  //
  // }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  int counter = 0;

  Timer.periodic(const Duration(seconds: 1), (timer) {
    counter++;
    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "counter": "$counter",
      },
    );
  });
}

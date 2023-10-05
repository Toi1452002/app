import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpmn/routers.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'bindings/innitial_binding.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        appBarTheme: const AppBarTheme(color: Colors.blueGrey),
        textTheme:const  TextTheme(
          titleMedium: TextStyle(fontSize: 15)
        )
      ),
      builder: EasyLoading.init(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales:const [
        // Locale('en', ''),
        Locale('vi', ''), // arabic, no country code
      ],
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.rightToLeft,
      initialBinding: InitialBinding(),
      getPages: getRouter(),
      title: 'TT_PMN',

    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
}

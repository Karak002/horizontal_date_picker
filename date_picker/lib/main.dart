import 'package:date_picker/widget/date_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

///Get.deviceLocale serve per prendere automaticamente la lingua del telefono per mostrare la lingua corretta

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  //Locale('en', 'US')
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Date Picker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? informazione;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            SizedBox(
                child: DatePicker(
              filterVisibility: true,
            )),
            Text(informazione.toString()),
          ],
        ));
  }
}

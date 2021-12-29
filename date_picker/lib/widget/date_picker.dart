import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../main.dart';

class CardModels {
  dynamic backgroundColor;
  dynamic textColor;
  DateTime data;

  CardModels({
    this.backgroundColor,
    required this.textColor,
    required this.data,
  });
}

class DatePicker extends StatefulWidget {
  final dynamic backgroundColor;
  final ValueChanged? onChanged;
  final bool filterVisibility;
  //l'altezza del widget viene calcolata in percentuale quindi 15 per esempio si riferisce al 15% dello spazio disponibile
  final double height;
  const DatePicker(
      {Key? key,
      required this.backgroundColor,
      this.onChanged,
      required this.filterVisibility,
      required this.height})
      : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> with Translations {
  List<CardModels> days = [];
  //funzione per creare la lista con 1 anno prima e 1 anno dopo rispetto la data odierna
  List<CardModels> calculateInterval(DateTime startDate, DateTime endDate) {
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(CardModels(
          backgroundColor: widget.backgroundColor,
          textColor: Colors.black,
          data: startDate.add(Duration(days: i))));
    }

    return days;
  }

  //Funzione per inizializzare i dati necessari per generare la lista
  createDateList() {
    final startDate = DateTime.now().subtract(const Duration(days: 365));
    final endDate = DateTime.now().add(const Duration(days: 365));
    final interval = calculateInterval(startDate, endDate);
  }

  setInitialvalue() {
    days.forEach((element) {
      if (DateFormat('yMEd').format(DateTime.now()) ==
          DateFormat('yMEd').format(element.data)) {
        element.backgroundColor = HexColor('FF7700');
      }
    });
  }

  @override
  //Nell'initstate si va ad eseguire la funzione createDateList() per generare all'apertuta dell'app la lista con le date
  void initState() {
    super.initState();
    createDateList();
    setInitialvalue();
    Get.updateLocale(locale!);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (controllerScroll.hasClients) {
        controllerScroll.position.jumpTo(32800);
        widget.onChanged!(DateTime.now());
      }
    });
  }

  final controllerScroll = ScrollController();
  // ignore: empty_constructor_bodies

  //controller per la listviewBuilder per scegliere la posizione iniziale

//Funzione per filtrare la lista in base al nome del mese che si va a premere
  filterList(String monthName) {
    List toRemove = [];
    days.clear();
    createDateList();
    controllerScroll.jumpTo(0);
    days.forEach((element) {
      if (DateFormat('MMMM').format(element.data) != monthName) {
        toRemove.add(element);
      }
    });
    days.removeWhere((element) => toRemove.contains(element));
    setInitialvalue();
    setState(() {});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.blockSizeVertical! * widget.height.toDouble(),
      width: SizeConfig.blockSizeHorizontal! * 100,
      constraints: const BoxConstraints(minHeight: 80, minWidth: 100),
      child: Column(
        children: [
          Visibility(
            visible: widget.filterVisibility,
            child: Container(
                alignment: AlignmentDirectional.centerStart,
                child: InkWell(
                    onTap: () {
                      print('Menu aperto');

                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title:
                                    Center(child: Text('Filtra per mese'.tr)),
                                content: Column(
                                  children: [
                                    Expanded(
                                      child: ListView(
                                        children: [
                                          Center(
                                              child: InkWell(
                                                  onTap: () {
                                                    filterList('January');
                                                  },
                                                  child: Text('January'.tr))),
                                          SizedBox(
                                            height:
                                                SizeConfig.blockSizeVertical! *
                                                    2,
                                          ),
                                          Center(
                                              child: InkWell(
                                                  onTap: () {
                                                    filterList('February');
                                                  },
                                                  child: Text('February'.tr))),
                                          SizedBox(
                                            height:
                                                SizeConfig.blockSizeVertical! *
                                                    2,
                                          ),
                                          Center(
                                              child: InkWell(
                                                  onTap: () {
                                                    filterList('March');
                                                  },
                                                  child: Text('March'.tr))),
                                          SizedBox(
                                            height:
                                                SizeConfig.blockSizeVertical! *
                                                    2,
                                          ),
                                          Center(
                                              child: InkWell(
                                                  onTap: () {
                                                    filterList('April');
                                                  },
                                                  child: Text('April'.tr))),
                                          SizedBox(
                                            height:
                                                SizeConfig.blockSizeVertical! *
                                                    2,
                                          ),
                                          Center(
                                              child: InkWell(
                                                  onTap: () {
                                                    filterList('May');
                                                  },
                                                  child: Text('May'.tr))),
                                          SizedBox(
                                            height:
                                                SizeConfig.blockSizeVertical! *
                                                    2,
                                          ),
                                          Center(
                                              child: InkWell(
                                                  onTap: () {
                                                    filterList('June');
                                                  },
                                                  child: Text('June'.tr))),
                                          SizedBox(
                                            height:
                                                SizeConfig.blockSizeVertical! *
                                                    2,
                                          ),
                                          Center(
                                              child: InkWell(
                                                  onTap: () {
                                                    filterList('July');
                                                  },
                                                  child: Text('July'.tr))),
                                          SizedBox(
                                            height:
                                                SizeConfig.blockSizeVertical! *
                                                    2,
                                          ),
                                          Center(
                                              child: InkWell(
                                                  onTap: () {
                                                    filterList('August');
                                                  },
                                                  child: Text('August'.tr))),
                                          SizedBox(
                                            height:
                                                SizeConfig.blockSizeVertical! *
                                                    2,
                                          ),
                                          Center(
                                              child: InkWell(
                                                  onTap: () {
                                                    filterList('September');
                                                  },
                                                  child: Text('September'.tr))),
                                          SizedBox(
                                            height:
                                                SizeConfig.blockSizeVertical! *
                                                    2,
                                          ),
                                          Center(
                                              child: InkWell(
                                                  onTap: () {
                                                    filterList('October');
                                                  },
                                                  child: Text('October'.tr))),
                                          SizedBox(
                                            height:
                                                SizeConfig.blockSizeVertical! *
                                                    2,
                                          ),
                                          Center(
                                              child: InkWell(
                                                  onTap: () {
                                                    filterList('November');
                                                  },
                                                  child: Text('November'.tr))),
                                          SizedBox(
                                            height:
                                                SizeConfig.blockSizeVertical! *
                                                    2,
                                          ),
                                          Center(
                                              child: InkWell(
                                                  onTap: () {
                                                    filterList('December');
                                                  },
                                                  child: Text('December'.tr))),
                                          SizedBox(
                                            height:
                                                SizeConfig.blockSizeVertical! *
                                                    4,
                                          ),
                                          Center(
                                              child: InkWell(
                                                  onTap: () {
                                                    days.clear();
                                                    createDateList();
                                                    setState(() {});
                                                    Navigator.pop(context);
                                                    controllerScroll
                                                        .jumpTo(32800);
                                                    setInitialvalue();
                                                  },
                                                  child: const Text(
                                                    'Remove filter',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  )))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ));
                    },
                    child: const Icon(Icons.arrow_drop_down_sharp))),
          ),
          Expanded(
            child: ListView.builder(
                controller: controllerScroll,
                scrollDirection: Axis.horizontal,
                itemCount: days.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: SizeConfig.blockSizeVertical! * 100,
                    width: SizeConfig.blockSizeHorizontal! * 25,
                    child: InkWell(
                      onTap: () {
                        for (var element in days) {
                          element.backgroundColor = Colors.white;
                        }
                        days[index].backgroundColor = HexColor('#FF7700');
                        widget.onChanged!(days[index].data.toString());
                        setState(() {});
                      },
                      child: Card(
                        elevation: 0,
                        color: days[index].backgroundColor,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 1, right: 1, top: 4, bottom: 4),
                              child: Text(
                                DateFormat('MMMM').format(days[index].data).tr,
                              ),
                            ),
                            const Spacer(),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                days[index].data.day.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 19),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              DateFormat('EEEE').format(days[index].data).tr,
                              style: const TextStyle(color: Colors.black),
                            ),
                            Text(
                              days[index].data.year.toString(),
                              style: const TextStyle(fontSize: 8),
                            ),
                            SizedBox(
                              height: SizeConfig.blockSizeVertical! * 0.5,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  @override
  Map<String, Map<String, String>> get keys => throw UnimplementedError();
}

//TRADUZIONI
class LocalString extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        //Lingua inglese, English language
        'en_US': {
          //Giorni della settimana
          'Monday': 'Monday',
          'Tuesday': 'Tuesday',
          'Wednesday': 'Wednesay',
          'Thursday': 'Thursday',
          'Friday': 'Friday',
          'Saturday': 'Saturday',
          'Sunday': 'Sunday',

          //Mesi
          'January': 'January',
          'February': 'February',
          'March': 'March',
          'April': 'April',
          'May': 'May',
          'June': 'June',
          'July': 'July',
          'August': 'August',
          'September': 'September',
          'October': 'October',
          'November': 'November',
          'December': 'December',
          //UI
          'Filtra per mese': 'Filter by month'
        },
        //Lingua italiana
        'it_IT': {
          //Giorni della settimana
          'Monday': 'Lunedì',
          'Tuesday': 'Martedì',
          'Wednesday': 'Mercoledì',
          'Thursday': 'Giovedì',
          'Friday': 'Venerdì',
          'Saturday': 'Sabato',
          'Sunday': 'Domenica',

          //Mesi
          'January': 'Gennaio',
          'February': 'Febbraio',
          'March': 'Marzo',
          'April': 'Aprile',
          'May': 'Maggio',
          'June': 'Giugno',
          'July': 'Luglio',
          'August': 'Agosto',
          'September': 'Settembre',
          'October': 'Ottobre',
          'November': 'Novembre',
          'December': 'Dicembre',

          //UI
          'Filtra per mese': 'Filtra per mese'
        }
      };
}

//mediaquery
class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? blockSizeHorizontal;
  static double? blockSizeVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData?.size.width;
    screenHeight = _mediaQueryData?.size.height;
    blockSizeHorizontal = screenWidth! / 100;
    blockSizeVertical = screenHeight! / 100;
  }
}

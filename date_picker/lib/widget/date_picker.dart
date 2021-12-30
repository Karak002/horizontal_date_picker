import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:io';

String? _localeLanguageDate;

class CardModels {
  dynamic backgroundColor;
  DateTime data;

  CardModels({
    this.backgroundColor,
    required this.data,
  });
}

class DatePicker extends StatefulWidget {
  ///serve per impostare il colore di background delle card, accetta valori di tipo **MaterialColor** o **Color**
  final dynamic backgroundColor;
  final ValueChanged? onChanged;

  /// Richiede un valore **booleano**, se false nasconde i filtri, se è true li mostra
  final bool? filterVisibility;

  ///Colore per il font all'interno delle tabs, richiede un valore di tipo **MaterialColor** o **Color**, il colore di default è nero
  final dynamic fontColor;

  ///l'altezza del widget viene calcolata in percentuale quindi 15 per esempio si riferisce al 15% dello spazio disponibile
  final double? height;

  ///Dimensione della stringa che rappresenta il mese nel calendario
  final int? monthFontSize;

  ///Dimenaione dei font delle scritte
  final int? textSize;

  ///Dimensione del numero al centro del widget
  final int? dayFontSize;

  ///Dimensione del font dell'anno numerico
  final double? dimensioneAnno;

  ///prende in input un tipo **DateTime**, sarà la data dalla quale il caldendario inizierà, Questo è un esempio di data corretta =>  DateTime.parse("2021-12-28")
  final DateTime? dataInizio;

  ///Prende in inuput un tipo **DateTime**, sarà la data dalla quale il calendario inizierà,  Questo è un esempio di data corretta =>  DateTime.parse("2021-12-28")
  final DateTime? dataFine;

  ///Prende in input un valore di tipo **String**, con la quale andrà a tradurre tutti i testi del calendario, [Qua la lista completa dei locale disponibili](https://pub.dev/documentation/intl/latest/date_symbol_data_http_request/availableLocalesForDateFormatting.html)
  final String? locale;

  const DatePicker(
      {Key? key,
      this.backgroundColor,
      this.onChanged,
      this.filterVisibility,
      this.height,
      this.fontColor,
      this.dataInizio,
      this.dayFontSize,
      this.textSize,
      this.dimensioneAnno,
      this.dataFine,
      this.locale,
      this.monthFontSize})
      : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  List<CardModels> days = [];

  ///funzione per creare la lista con 1 anno prima e 1 anno dopo rispetto la data odierna
  List<CardModels> calculateInterval(DateTime startDate, DateTime endDate) {
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(CardModels(
          backgroundColor: widget.backgroundColor ?? Colors.white,
          data: startDate.add(Duration(days: i))));
    }

    return days;
  }

  var _difference;

  ///Funzione per inizializzare i dati necessari per generare la lista
  createDateList() {
    final startDate =
        widget.dataInizio ?? DateTime.now().subtract(const Duration(days: 365));
    final endDate =
        widget.dataFine ?? DateTime.now().add(const Duration(days: 365));
    final interval = calculateInterval(startDate, endDate);
  }

  ///Funzione per impostare il valore iniziale del calendario al giorno odierno
  setInitialvalue() {
    days.forEach((element) {
      if (DateFormat('yMEd').format(DateTime.now()) ==
          DateFormat('yMEd').format(element.data)) {
        element.backgroundColor = HexColor('FF7700');
      }
    });
  }

  ///Funzione per inizializzare il linguaggio del calendario, che nel caso in cui non venga passato al costruttore prenderà in defalut quello del telefono
  setLocalLanguage() {
    _localeLanguageDate = widget.locale ?? Platform.localeName;
  }

  @override

  ///Nell'initstate si vanno ad eseguire tutte le funzioni di iniziallizzazione per fornire tutte le informazioni necessarie al calendario per funzionare
  void initState() {
    super.initState();
    setLocalLanguage();
    initializeDateFormatting();
    createDateList();
    setInitialvalue();
    //Get.updateLocale();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (controllerScroll.hasClients) {
        controllerScroll.position.jumpTo(32800);
        widget.onChanged!(DateTime.now());
      }
    });
  }

  final controllerScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.blockSizeVertical! * (widget.height ?? 14),
      width: SizeConfig.blockSizeHorizontal! * 100,
      constraints: const BoxConstraints(minHeight: 80, minWidth: 100),
      child: Column(
        children: [
          // Visibility(
          //   visible: widget.filterVisibility,
          //   child: Container(
          //       alignment: AlignmentDirectional.centerStart,
          //       child: InkWell(
          //           onTap: () {
          //             showDialog(
          //                 context: context, builder: (_) => AlertDialog());
          //           },
          //           child: const Icon(Icons.arrow_drop_down_sharp))),
          // ),
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
                          element.backgroundColor = widget.backgroundColor;
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
                                DateFormat('MMMM', _localeLanguageDate)
                                    .format(days[index].data),
                                style: TextStyle(
                                    color: widget.fontColor ?? Colors.black,
                                    fontSize:
                                        widget.monthFontSize?.toDouble() ?? 14),
                              ),
                            ),
                            const Spacer(),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                days[index].data.day.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        widget.dayFontSize?.toDouble() ?? 19,
                                    color: widget.fontColor ?? Colors.black),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              DateFormat('EEEE', _localeLanguageDate)
                                  .format(days[index].data),
                              style: TextStyle(
                                color: widget.fontColor ?? Colors.black,
                              ),
                            ),
                            Text(
                              days[index].data.year.toString(),
                              style: TextStyle(
                                  fontSize: widget.dimensioneAnno ?? 8,
                                  color: widget.fontColor ?? Colors.black),
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

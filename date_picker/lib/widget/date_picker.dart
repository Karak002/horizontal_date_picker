import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:io';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

String? _localeLanguageDate;
String _yearIndex = '';
int counter = 0;

///List _listaAnni andrà a contenere tutti gli anni che poi andrò a filtrare
final List _listaAnni = [];

///Modello per creare i testi che saranno nel menù del filtro così che si possa avere la possibilità di modificare i loro parametri, l'ho utilizzata per avere la possibilità di evidenziare il campo attivo
class TextModels {
  Text testo;
  dynamic colore;

  TextModels(this.colore, this.testo);
}

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

  ///Callback che va a riportare il valore della variabile ogni vvolta che vengono eseguite modifiche sul widget, ad esempio il click su una data diversa da quella già selezionata
  final ValueChanged? onChanged;

  /// Richiede un valore **booleano**, se false nasconde i filtri, se è true li mostra
  final bool filterVisibility;

  ///Colore per il font all'interno delle tabs, richiede un valore di tipo **MaterialColor** o **Color**, il colore di default è nero
  final dynamic fontColor;

  ///l'altezza del widget viene calcolata in percentuale quindi 15 per esempio si riferisce al 15% dello spazio disponibile
  final double? height;

  ///Dimensione della stringa che rappresenta il mese nel calendario
  final int? monthFontSize;

  ///Dimensione del numero al centro del widget
  final int? dayFontSize;

  ///Dimensione del font dell'anno numerico
  final double? dimensioneAnno;

  ///prende in input un tipo **DateTime**, sarà la data dalla quale il caldendario inizierà, Questo è un esempio di data corretta =>  DateTime.parse("2023-01-25 10:06") 10:06 rappresenta l'ora ed il minuto
  final DateTime? dataInizio;

  ///Prende in inuput un tipo **DateTime**, sarà la data dalla quale il calendario inizierà,  Questo è un esempio di data corretta =>  DateTime.parse("2023-01-25 10:06") 10.06 rappresenta l'ora ed il minuto
  final DateTime? dataFine;

  ///Prende in input un valore di tipo **String**, con la quale andrà a tradurre tutti i testi del calendario, [Qua la lista completa dei locale disponibili](https://pub.dev/documentation/intl/latest/date_symbol_data_http_request/availableLocalesForDateFormatting.html)
  final String? locale;

  ///Prende in input un valore di tipo intero(int) e lo imposta come grandezza del font del nome del giorno
  final int? dayNameFontSize;

  ///Prende in input un tipo String che rappresenterà il nome della font-family da utilizzare ad esempio: 'Roboto'
  final String? fontFamily;

  ///Colore che viene assegnato alla card che viene selezionata, accetta valori di tipo **MaterialColor** oppure **Color**
  final dynamic selectColor;

  const DatePicker(
      {Key? key,
      this.backgroundColor,
      this.onChanged,
      required this.filterVisibility,
      this.height,
      this.fontColor,
      this.dataInizio,
      this.dayFontSize,
      this.dimensioneAnno,
      this.dayNameFontSize,
      this.dataFine,
      this.locale,
      this.monthFontSize,
      this.fontFamily,
      this.selectColor})
      : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  List<CardModels> days = [];

  ///funzione per creare la lista dei giorni con gli anni in base alla data iniziale e alla data finale
  List<CardModels> calculateInterval(DateTime startDate, DateTime endDate) {
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(CardModels(
          backgroundColor: widget.backgroundColor ?? Colors.white,
          data: startDate.add(Duration(days: i))));
    }

    return days;
  }

  ///Funzione per inizializzare i dati necessari per generare la lista
  createDateList() {
    final startDate =
        widget.dataInizio ?? DateTime.now().subtract(const Duration(days: 365));
    final endDate =
        widget.dataFine ?? DateTime.now().add(const Duration(days: 365));
    final interval = calculateInterval(startDate, endDate);
  }

  filterList(int year) {
    List toRemove = [];
    days.clear();
    createDateList();

    days.forEach((element) {
      if (element.data.year != year) {
        toRemove.add(element);
      }
    });
    days.removeWhere((element) => toRemove.contains(element));
    setInitialvalue();
    setState(() {});
    Navigator.pop(context);
  }

  ///Funzione per impostare il valore iniziale del calendario al giorno odierno
  setInitialvalue() {
    counter = 0;
    for (var element in days) {
      if (DateFormat('yMEd').format(DateTime.now()) ==
          DateFormat('yMEd').format(element.data)) {
        element.backgroundColor = widget.selectColor ?? HexColor('FF7700');
        break;
        // widget.onChanged!(DateTime.now());
      } else {
        counter++;
      }
    }
    print(counter);
  }

  ///Funzione per inizializzare il linguaggio del calendario, che nel caso in cui non venga passato al costruttore prenderà in defalut quello del telefono
  setLocalLanguage() {
    _localeLanguageDate = widget.locale ?? Platform.localeName;
  }

  int provina = 0;

  ///Funzione che va a calcolare gli anni per poi poterli utilizzare per filtrare la lista
  calculateYearFilter() {
    days.forEach((element) {
      if (_listaAnni.contains(element.data.year)) {
      } else {
        provina++;
        print(provina);
        _listaAnni.add(element.data.year);
        _textAnni
            .add(TextModels(Colors.grey, Text(element.data.year.toString())));
      }
    });
  }

  final ItemScrollController itemScrollController = ItemScrollController();

  @override

  ///Nell'initstate si vanno ad eseguire tutte le funzioni di iniziallizzazione per fornire tutte le informazioni necessarie al calendario per funzionare
  void initState() {
    super.initState();
    setLocalLanguage();
    initializeDateFormatting();
    createDateList();
    setInitialvalue();
    calculateYearFilter();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      itemScrollController.jumpTo(index: counter);
      widget.onChanged!(DateTime.now());
    });
  }

  DateTime selectedDate = DateTime.now();
  List<TextModels> _textAnni = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.blockSizeVertical! * (widget.height ?? 14),
      width: SizeConfig.blockSizeHorizontal! * 100,
      constraints: const BoxConstraints(minHeight: 80, minWidth: 100),
      child: Column(
        children: [
          Visibility(
            visible: widget.filterVisibility,
            child: Container(
                alignment: AlignmentDirectional.centerStart,
                child: InkWell(
                    child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    content: Column(
                                      children: [
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: _textAnni.length,
                                            itemBuilder: (context, index) {
                                              return Column(
                                                children: [
                                                  Center(
                                                    child: InkWell(
                                                      onTap: () {
                                                        filterList(int.parse(
                                                            _textAnni[index]
                                                                .testo
                                                                .data
                                                                .toString()));
                                                        _yearIndex =
                                                            _textAnni[index]
                                                                .testo
                                                                .data
                                                                .toString();
                                                        _textAnni
                                                            .forEach((element) {
                                                          element.colore =
                                                              Colors.grey;
                                                        });
                                                        _textAnni[index]
                                                                .colore =
                                                            Colors.black;
                                                        setState(() {});
                                                      },
                                                      child: Text(
                                                        _textAnni[index]
                                                            .testo
                                                            .data
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 19,
                                                            color:
                                                                _textAnni[index]
                                                                    .colore),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: SizeConfig
                                                            .blockSizeVertical! *
                                                        2,
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                        InkWell(
                                          child: CircleAvatar(
                                            child: IconButton(
                                              onPressed: () {
                                                days.clear();
                                                _textAnni.forEach((element) {
                                                  element.colore = Colors.grey;
                                                });
                                                _yearIndex = '';
                                                setState(() {});
                                                createDateList();
                                                Navigator.pop(context);
                                                setInitialvalue();
                                                itemScrollController.jumpTo(
                                                    index: counter);
                                              },
                                              icon: const Icon(
                                                  Icons.cleaning_services),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ));
                        },
                        child: const Icon(Icons.arrow_drop_down_sharp)),
                    Text(_yearIndex)
                  ],
                ))),
          ),
          Expanded(
            child: ScrollablePositionedList.builder(
                itemScrollController: itemScrollController,
                scrollDirection: Axis.horizontal,
                itemCount: days.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: SizeConfig.blockSizeVertical! * 100,
                    width: SizeConfig.screenWidth! * 0.25,
                    child: InkWell(
                      onTap: () {
                        for (var element in days) {
                          element.backgroundColor = widget.backgroundColor;
                        }
                        days[index].backgroundColor =
                            widget.selectColor ?? HexColor('#FF7700');
                        selectedDate = days[index].data;
                        widget.onChanged!(selectedDate);
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
                                        widget.monthFontSize?.toDouble() ?? 14,
                                    fontFamily: widget.fontFamily ??
                                        Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.fontFamily),
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
                                  color: widget.fontColor ?? Colors.black,
                                  fontFamily: widget.fontFamily ??
                                      Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.fontFamily,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              DateFormat('EEEE', _localeLanguageDate)
                                  .format(days[index].data),
                              style: TextStyle(
                                  color: widget.fontColor ?? Colors.black,
                                  fontSize:
                                      widget.dayNameFontSize?.toDouble() ?? 15,
                                  fontFamily: widget.fontFamily ??
                                      Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.fontFamily),
                            ),
                            Text(
                              days[index].data.year.toString(),
                              style: TextStyle(
                                  fontFamily: widget.fontFamily ??
                                      Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.fontFamily,
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

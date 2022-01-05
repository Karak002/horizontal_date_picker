// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:io';

///Stringa che va a contenere il linguaggio da utilizzare nell'app
String? _localeLanguageDate;

///Stringa che contiene l'anno corrente dell'filtro attivo
String _yearIndex = '';

///Counter che vado ad utilizzare per trovare all'interno della lista days il giorno corrente
double counter = 0;

///Lista che andrà a contenere le date da eliminare che non sono presenti nel risultato del filtro
List toRemove = [];

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

  ///Prende in input un valore di tipo Double, 0.20 equivale ad 20%
  final double? width;

  ///l'altezza del widget viene calcolata in percentuale quindi 15 per esempio si riferisce al 15% dello spazio disponibile
  final num? height;

  ///Dimensione della stringa che rappresenta il mese nel calendario
  final double? monthFontSize;

  ///Dimensione del numero al centro del widget
  final double? dayFontSize;

  ///Dimensione del font dell'anno numerico
  final double? dimensioneAnno;

  ///prende in input un tipo **DateTime**, sarà la data dalla quale il caldendario inizierà, Questo è un esempio di data corretta =>  DateTime.parse("2023-01-25 10:06") 10:06 rappresenta l'ora ed il minuto
  final DateTime? dataInizio;

  ///Prende in inuput un tipo **DateTime**, sarà la data dalla quale il calendario inizierà,  Questo è un esempio di data corretta =>  DateTime.parse("2023-01-25 10:06") 10.06 rappresenta l'ora ed il minuto
  final DateTime? dataFine;

  ///Prende in input un valore di tipo **String**, con la quale andrà a tradurre tutti i testi del calendario, [Qua la lista completa dei locale disponibili](https://pub.dev/documentation/intl/latest/date_symbol_data_http_request/availableLocalesForDateFormatting.html)
  final String? locale;

  ///Prende in input un valore di tipo intero(int) e lo imposta come grandezza del font del nome del giorno
  final double? dayNameFontSize;

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
      this.width,
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
  createDateList() async {
    final startDate =
        widget.dataInizio ?? DateTime.now().subtract(const Duration(days: 365));
    final endDate =
        widget.dataFine ?? DateTime.now().add(const Duration(days: 365));
    final interval = calculateInterval(startDate, endDate);
  }

  ///Funzione che viene triggerata dopo la selezione di un anno nel menù del filtro, serve per togliere dalla lista tutti gli elementi che non ci interessano
  filterList(int year) {
    days.clear();
    createDateList();
    counter = 0;

    for (var element in days) {
      if (element.data.year != year) {
        toRemove.add(element);
      }
    }
    days.removeWhere((element) => toRemove.contains(element));
    setInitialvalue();
    setState(() {});
    Navigator.pop(context);
  }

  ///Funzione che viene triggerata quando si preme il bottone per pulire il filtro, riporterà la lista allo stato iniziale uilizzando come index il giorno corrente
  clearButton() async {
    _yearIndex = '';
    counter = 0;
    days.clear();
    for (var element in textAnni) {
      element.colore = Colors.grey;
    }
    createDateList();
    setInitialvalue();
    scrollController.jumpTo(widgetWidth!.toDouble() * counter);
    setState(() {});
    Navigator.pop(context);
  }

  //todo logica dello slider
  ///DialogMenu ritorna la lista degli anni disponibili per filtrare i risultati nel calendario
  dialogMenu() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: textAnni.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Center(
                    child: InkWell(
                      onTap: () {
                        filterList(
                            int.parse(textAnni[index].testo.data.toString()));
                        _yearIndex = textAnni[index].testo.data.toString();
                        for (var element in textAnni) {
                          element.colore = Colors.grey;
                        }
                        textAnni[index].colore = Colors.black;
                        //serie di if per impostare il punto di partenza della listview, se un anno è meno recente dell'anno corrente la listview partirà alla fine, al contrario se è più recente partirà dall'inizio, mentre se si clicca sull'anno corrente partirà dal giorno corrente
                        if (DateTime.now().year.toString() ==
                            textAnni[index].testo.data) {
                          scrollController.jumpTo(widgetWidth! * counter);
                        } else if (_yearIndex != '') {
                          var data = days.last;
                          bool valDate = data.data.isBefore(DateTime.now());
                          if (valDate == true) {
                            scrollController
                                .jumpTo(widgetHeight! * days.length);
                          } else {
                            scrollController.jumpTo(1);
                          }
                        }
                        setState(() {});
                      },
                      child: Text(
                        textAnni[index].testo.data.toString(),
                        style: TextStyle(
                            fontSize: 19, color: textAnni[index].colore),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical! * 2,
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
                clearButton();
              },
              icon: const Icon(Icons.cleaning_services),
            ),
          ),
        )
      ],
    );
  }

  ///Funzione per impostare il valore iniziale del calendario al giorno odierno
  setInitialvalue() {
    counter = 0;

    for (var element in days) {
      if (DateFormat('yMEd').format(DateTime.now()) ==
          DateFormat('yMEd').format(element.data)) {
        element.backgroundColor = selectColor;
        break;
      } else {
        counter++;
      }
    }
  }

  ///Funzione per inizializzare il linguaggio del calendario, che nel caso in cui non venga passato al costruttore prenderà in defalut quello del telefono
  setLocalLanguage() {
    _localeLanguageDate = widget.locale ?? Platform.localeName;
  }

  ///Funzione che va a calcolare gli anni per poi poterli utilizzare per filtrare la lista
  calculateYearFilter() {
    for (var element in days) {
      if (_listaAnni.contains(element.data.year)) {
      } else {
        _listaAnni.add(element.data.year);
        textAnni
            .add(TextModels(Colors.grey, Text(element.data.year.toString())));
      }
    }
  }

  ///widgetHeight rappresenta l'altezza del widget
  double? widgetHeight;

  ///WidgetWidth rappresenta la larghezza del widget
  double? widgetWidth;

  ///Rappresenta il colore di background della card che viene scelta
  dynamic selectColor;

  ///Colore del font utilizzato all'interno del widget
  dynamic fontColor;

  double? fontSize;

  double? fontAnnoSize;

  double? fontNumberSize;

  ///Serve per inizializzare tutti i valori che poi sarannò utilizzati per la grafica del calendario, tenendo i valori del costruttore e usando quelli di default se non vengono foniti dall'utente
  initializeConstantValue() {
    if (widget.filterVisibility == true) {
      widgetHeight = SizeConfig.blockSizeVertical! * (widget.height ?? 17);
    } else {
      widgetHeight = SizeConfig.blockSizeVertical! * (widget.height ?? 15);
    }

    selectColor = widget.selectColor ?? HexColor('FF7700');
    widgetWidth = SizeConfig.screenWidth! * (widget.width ?? 0.25);
    fontColor = widget.fontColor ?? Colors.black;
    fontSize = widget.monthFontSize ?? 14;
    fontAnnoSize = widget.dimensioneAnno ?? 8;
    fontNumberSize = widget.dayFontSize ?? 15;
  }

  @override

  ///Nell'initstate si vanno ad eseguire tutte le funzioni di iniziallizzazione per fornire tutte le informazioni necessarie al calendario per funzionare
  void initState() {
    super.initState();
    initializeConstantValue();
    setLocalLanguage();
    initializeDateFormatting();
    createDateList();
    setInitialvalue();
    calculateYearFilter();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      widget.onChanged!(DateTime.now());
      scrollController.jumpTo(widgetWidth!.toDouble() * counter);
    });
  }

  DateTime selectedDate = DateTime.now();
  List<TextModels> textAnni = [];
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widgetHeight,
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
                                    content: dialogMenu(),
                                  ));
                        },
                        child: const Icon(Icons.arrow_drop_down_sharp)),
                    Text(_yearIndex)
                  ],
                ))),
          ),
          Expanded(
            child: ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: days.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: SizeConfig.blockSizeVertical! * 100,
                    width: widgetWidth!.toDouble(),
                    child: InkWell(
                      onTap: () {
                        for (var element in days) {
                          element.backgroundColor = widget.backgroundColor;
                        }
                        days[index].backgroundColor = selectColor;
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
                                    color: fontColor,
                                    fontSize: fontSize,
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
                                  fontSize: fontNumberSize,
                                  color: fontColor,
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
                                  color: fontColor,
                                  fontSize: fontSize,
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
                                  fontSize: fontAnnoSize,
                                  color: fontColor),
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

///SizeConfig non è altro che la dichiarazione di tutti i metodi necessari per creare applicazioni responsive senza richiamare sempre i metodi di mediaquery.
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

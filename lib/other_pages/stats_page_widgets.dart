import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vxstate/vxstate.dart';

import '../store/classes/answer.dart';
import '../store/mutations/questions_mutations.dart';
import '../store/mystore.dart';
import '../constants.dart' as constants;

List<Color> gradientColors = [
  const Color(0xff23b6e6),
  const Color(0xff02d39a),
];

TextStyle bottomTextStyle = TextStyle(
  color: constants.secondColor,
  fontSize: 25.0,
);

TextStyle bottomNumberStyle = TextStyle(
  color: constants.thirdColor,
  fontSize: 70.0,
);

Widget leftTileWidgets(double value, TitleMeta meta) {
  TextStyle style = TextStyle(
    color: constants.secondColor,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  if ((value * 10).round() % 2 == 0 && (value * 10).round() != 10) {
    //We only take percentage multiple of 20
    String text = (value * 100).round().toString() + '%';
    return Text(text, style: style, textAlign: TextAlign.center);
  }
  return Container();
}

double sizeLeft = 34.0;

Widget getBottomTitlesWidget(DateTime filterSince) {
  TextStyle style = TextStyle(
    color: constants.secondColor,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  MyStore store = VxState.store;

  DateTime mostRecentDate = filterSince.compareTo(store.answers[0].date) > 0
      ? filterSince
      : store.answers[0].date;

  DateFormat format = DateFormat('d MMM', 'fr_FR');

  String formattedDateLeft = format.format(mostRecentDate).toUpperCase();

  String formattedDateRight =
      format.format(constants.getTodaysDate()).toUpperCase();

  int diff = ((DateTime.now().millisecondsSinceEpoch -
              mostRecentDate.millisecondsSinceEpoch) /
          2)
      .round();
  DateTime dateCenter = DateTime.now().subtract(Duration(milliseconds: diff));
  String formattedDateCenter = format.format(dateCenter).toUpperCase();

  Widget textLeft =
      Text(formattedDateLeft, style: style, textAlign: TextAlign.center);
  Widget textCenter =
      Text(formattedDateCenter, style: style, textAlign: TextAlign.center);
  Widget textRight =
      Text(formattedDateRight, style: style, textAlign: TextAlign.center);

  Widget row = Row(
    children: [
      Container(
        width: sizeLeft,
      ),
      textLeft,
      const Spacer(),
      textCenter,
      const Spacer(),
      textRight,
    ],
  );

  return row;
}

List<Map<String, dynamic>> getDataGraph(
    List<String> categories, DateTime filterSince) {
  MyStore store = VxState.store;
  List<Answer> answersFiltered = store.answers
      .where((answer) =>
          answer.date.compareTo(filterSince) >= 0 &&
          (categories.isEmpty || categories.contains(answer.category)))
      .toList();

  if (answersFiltered.isEmpty) {
    answersFiltered.add(Answer(DateTime.now(), false, 0, 0, ""));
    //Graph show nothing
  }

  List<Map<String, dynamic>> data = [];
  data.add({
    'date': constants.getDayDate(answersFiltered[0].date),
    'index': 1,
    'count': answersFiltered[0].isCorrect ? 1 : 0,
  });

  //add data containing dates and answers
  for (int i = 0; i < answersFiltered.length; i++) {
    if (constants.getDayDate(answersFiltered[i].date) ==
        data[data.length - 1]['date']) {
      data[data.length - 1]['index']++;
      if (answersFiltered[i].isCorrect) {
        data[data.length - 1]['count']++;
      }
    } else {
      data.add({
        'date': constants.getDayDate(answersFiltered[i].date),
        'index': data[data.length - 1]['index'] + 1,
        'count': data[data.length - 1]['count'] +
            (answersFiltered[i].isCorrect ? 1 : 0),
      });
    }
  }

  int numberOfDaysMissing = (data[data.length - 1]['date'] as DateTime)
      .difference(DateTime.now())
      .inDays
      .abs();
  // fill list until today
  for (int i = 0; i < numberOfDaysMissing; i++) {
    data.add({
      'index': data[data.length - 1]['index'],
      'count': data[data.length - 1]['count']
    });
  }
  return data;
}

List<FlSpot> getPointsFromAnswers(
    List<String> categories, DateTime filterSince) {
  List<FlSpot> list = [];

  List<Map<String, dynamic>> data = getDataGraph(categories, filterSince);

  for (int i = 0; i < data.length; i++) {
    list.add(FlSpot(
        i.toDouble(),
        (data[i]['count'] as int).toDouble() /
            (data[i]['index'] as int).toDouble()));
  }

  return list;
}

Widget getGraph(List<String> selectedCategories, DateTime filterSince) {
  return Container(
    margin: const EdgeInsets.only(
      right: 30.0,
      left: 30.0,
      top: 30.0,
    ),
    height: 300,
    child: VxBuilder<MyStore>(
      builder: (context, store, status) {
        return LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              enabled: false,
            ),
            minY: 0,
            maxY: 1,
            gridData: FlGridData(
              drawVerticalLine: false,
              getDrawingHorizontalLine: getDrawingHorizontalLine,
            ),
            lineBarsData: [
              LineChartBarData(
                preventCurveOverShooting: true,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: gradientColors
                        .map((color) => color.withOpacity(0.3))
                        .toList(),
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                isCurved: true,
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                dotData: FlDotData(
                  show: false,
                ),
                spots: getPointsFromAnswers(selectedCategories, filterSince),
              ),
            ],
            titlesData: FlTitlesData(
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                axisNameWidget: getBottomTitlesWidget(filterSince),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: leftTileWidgets,
                  reservedSize: sizeLeft,
                ),
              ),
            ),
          ),
        );
      },
      mutations: const {PostAnswer, FetchAnswers},
    ),
  );
}

FlLine getDrawingHorizontalLine(double value) {
  double strokeWidth =
      ((value * 10).round() % 2 == 0 && (value * 10).round() != 10) ? 1 : 0;
  return FlLine(
      strokeWidth: strokeWidth,
      color: const Color.fromARGB(173, 180, 180, 180));
}

Widget getBottomsWidget(String text, int number) {
  return Column(
    children: [
      Text(
        text,
        textAlign: TextAlign.center,
        style: bottomTextStyle,
      ),
      Text(
        number.toString(),
        style: bottomNumberStyle,
      )
    ],
  );
}

List<Widget> getBottomStats() {
  MyStore store = VxState.store;
  AutoSizeGroup textGroup = AutoSizeGroup();
  AutoSizeGroup dataGroup = AutoSizeGroup();

  return [
    Row(
      children: [
        const Spacer(),
        Expanded(
          flex: 8,
          child: AutoSizeText(
            'Bonnes Réponses',
            style: bottomTextStyle,
            maxLines: 2,
            textAlign: TextAlign.center,
            group: textGroup,
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 8,
          child: AutoSizeText(
            'Plus longue série',
            maxLines: 3,
            style: bottomTextStyle,
            textAlign: TextAlign.center,
            group: textGroup,
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 8,
          child: AutoSizeText(
            'Série en cours',
            maxLines: 2,
            style: bottomTextStyle,
            textAlign: TextAlign.center,
            group: textGroup,
          ),
        ),
        const Spacer(),
      ],
    ),
    Row(
      children: [
        const Spacer(),
        Expanded(
          flex: 8,
          child: AutoSizeText(
            store.getNumberCorrectAnswers().toString(),
            style: bottomNumberStyle,
            textAlign: TextAlign.center,
            group: dataGroup,
            maxLines: 1,
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 8,
          child: AutoSizeText(
            store.getLongestStreak().toString(),
            style: bottomNumberStyle,
            textAlign: TextAlign.center,
            group: dataGroup,
            maxLines: 1,
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 8,
          child: AutoSizeText(
            store.getCurrentStreak().toString(),
            style: bottomNumberStyle,
            textAlign: TextAlign.center,
            group: dataGroup,
            maxLines: 1,
          ),
        ),
        const Spacer(),
      ],
    ),
  ];
}

Widget getDropDownMenuItemChild(String text) {
  return Container(
    alignment: Alignment.center,
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
  );
}

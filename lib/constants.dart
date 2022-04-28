import 'package:flutter/material.dart';

const String passwordKey = 'password';
const String emailKey = 'email';
const String stayCoKey = 'stayConnected';
const String qotdLastDoneDateKey = 'qotdLastDoneDate';
const String qotdResults = 'qotdResults';

const String apiURL = 'https://murmuring-fjord-44933.herokuapp.com/api/';
const String loginURL = apiURL + 'token/';
const String refreshURL = apiURL + 'token/refresh/';
const String registerURL = apiURL + 'register/';
const String qotdURL = apiURL + 'get_questions_of_the_day/';
const String anwserURL = apiURL + 'answer_question/';
const String getAnswerURL = apiURL + 'get_answers/';

const int qotdNumber = 5;

const Map<String, String> headers = <String, String>{
  'Content-Type': 'application/json; charset=UTF-8',
};

const Map<String, String> headersAnswer = <String, String>{
  'Content-Type': 'application/json',
  'Accept': 'application/json',
};

Color mainColor = Colors.blueGrey.shade100;
Color secondColor = const Color.fromARGB(255, 43, 45, 61);
Color thirdColor = const Color.fromARGB(255, 225, 105, 40);
MaterialColor mainMaterialColor = Colors.blueGrey;

DateTime getTodaysDate() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

int getTimeBeforeNextDay() {
  DateTime nextDay = DateTime.now().add(const Duration(days: 1));
  DateTime nextDayMidNight = DateTime(nextDay.year, nextDay.month, nextDay.day);
  return nextDayMidNight.millisecondsSinceEpoch;
}

bool isToday(DateTime date) {
  DateTime today = getTodaysDate();
  DateTime compare = DateTime(date.year, date.month, date.day);
  return today == compare;
}

DateTime getDayDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

const List<String> categories = [
  'Physique',
  'Logement',
  'Transport',
  'Agriculture',
  'Énergie',
  'Impacts',
  'Industrie',
];

const List<Map<String, dynamic>> carouselData = [
  {
    'text': 'Physique',
    'logo': '028-global-warming.svg',
  },
  {
    'text': 'Logement',
    'logo': '037-urban.svg',
  },
  {
    'text': 'Transport',
    'logo': '003-electric-car.svg',
  },
  {
    'text': 'Agriculture',
    'logo': '016-plant.svg',
  },
  {
    'text': 'Énergie',
    'logo': '046-eco-fuel.svg',
  },
  {
    'text': 'Impacts',
    'logo': '031-drought.svg',
  },
  {
    'text': 'Industrie',
    'logo': '036-production.svg',
  },
];

List<Map<String, dynamic>> levels = [
  {
    'status': 'Débutant',
  },
  {
    'status': 'Intermédiaire',
    'nbOfAnswers': 20,
    'percentageCorrectAnswers': 40
  },
  {'status': 'Avancé', 'nbOfAnswers': 60, 'percentageCorrectAnswers': 60},
  {'status': 'Expert', 'nbOfAnswers': 200, 'percentageCorrectAnswers': 80},
];

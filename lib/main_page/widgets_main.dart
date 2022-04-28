import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vxstate/vxstate.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../constants.dart' as constants;
import '../store/mutations/questions_mutations.dart';
import '../store/mystore.dart';

TextStyle mainStyle = TextStyle(
  color: constants.thirdColor,
  decoration: TextDecoration.underline,
);

Widget mainText = Builder(
  builder: (BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
      ),
      child: AutoSizeText.rich(
        TextSpan(
          text: 'Teste tes ',
          style: TextStyle(
            fontSize: 25.0,
            color: constants.secondColor,
            fontWeight: FontWeight.bold,
          ),
          children: <TextSpan>[
            TextSpan(text: 'connaissances\n', style: mainStyle),
            const TextSpan(text: 'sur le '),
            TextSpan(text: 'réchauffement climatique', style: mainStyle),
          ],
        ),
        maxLines: 2,
        minFontSize: 8,
      ),
    );
  },
);

List<Widget> getCarouselWidgets() {
  AutoSizeGroup myGroup = AutoSizeGroup();
  return constants.carouselData.map(
    (element) {
      return Builder(
        builder: (BuildContext context) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Container(
                    height: 50,
                    width: 50,
                    color: Colors.transparent,
                    child: SvgPicture.asset(
                      'assets/' + element['logo'],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: AutoSizeText(
                      element['text'],
                      group: myGroup,
                      maxLines: 1,
                      style: TextStyle(
                        color: constants.secondColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  ).toList();
}

List<Widget> shuffleWidgets(List<Widget> list) {
  list.shuffle();
  return list;
}

Widget carousel = SizedBox(
  height: 150.0,
  child: CarouselSlider(
    items: shuffleWidgets(getCarouselWidgets()),
    options: CarouselOptions(
      height: 150.0,
      viewportFraction: 0.3,
      autoPlay: true,
    ),
  ),
);

ButtonStyle buttonStyle = ElevatedButton.styleFrom(
  minimumSize: const Size.fromHeight(70.0),
  primary: constants.secondColor,
);

TextStyle buttonTextStyle = const TextStyle(
  fontSize: 20.0,
);

Widget bottomButton = Builder(
  builder: (BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.05,
        right: MediaQuery.of(context).size.width * 0.05,
        bottom: MediaQuery.of(context).size.width * 0.05,
      ),
      child: VxBuilder<MyStore>(
        builder: (context, store, status) {
          if (!store.qotdDone) {
            return ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                Navigator.pushNamed(context, '/questions');
              },
              child: Text(
                store.currentQuestion == 0 ? 'COMMENCER' : 'CONTINUER',
                style: buttonTextStyle,
              ),
            );
          } else {
            return ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                Navigator.pushNamed(context, '/results');
              },
              child: Text(
                'VOIR MES RÉSULTATS',
                style: buttonTextStyle,
              ),
            );
          }
        },
        mutations: const {NextQuestion, FetchAnswers},
      ),
    );
  },
);

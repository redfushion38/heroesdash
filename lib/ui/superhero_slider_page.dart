import 'dart:math';

import 'package:bookstore_app/models/superhero.dart';
import 'package:bookstore_app/ui/superhero_detail_page.dart';
import 'package:bookstore_app/ui/widgets/superhero_card.dart';
import 'package:flutter/material.dart';

class SuperheroSliderPage extends StatefulWidget {
  const SuperheroSliderPage({super.key});

  @override
  SuperheroSliderPageState createState() => SuperheroSliderPageState();
}

class SuperheroSliderPageState extends State<SuperheroSliderPage> {
  PageController? _pageController;
  late int _index;
  late int _auxIndex;
  double? _percent;
  double? _auxPercent;
  late bool _isScrolling;

  @override
  void initState() {
    _pageController = PageController();
    _index = 0;
    _auxIndex = _index + 1;
    _percent = 0.0;
    _auxPercent = 1.0 - _percent!;
    _isScrolling = false;
    _pageController!.addListener(_pageListener);
    super.initState();
  }

  @override
  void dispose() {
    _pageController!
      ..removeListener(_pageListener)
      ..dispose();
    super.dispose();
  }

  //page view listener

  void _pageListener() {
    _index = _pageController!.page!.floor();
    _auxIndex = _index + 1;
    _percent = (_pageController!.page! - _index).abs();
    _auxPercent = 1.0 - _percent!;

    _isScrolling = _pageController!.page! % 1.0 != 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const heroes = Superhero.marvelHeroes;
    const angleRotate = -pi * .5;
    return Scaffold(
      //appbar
      appBar: AppBar(
        title: const Text('movies'),
        elevation: 0,
        centerTitle: true,
        leading: Hero(
          tag: 'back.button.tag',
          child: Material(
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          //cartas heroes
          AnimatedPositioned(
            duration: kThemeAnimationDuration,
            top: 0,
            bottom: 0,
            right: _isScrolling ? 10 : 0,
            left: _isScrolling ? 10 : 0,
            child: Stack(
              children: [
                // TARJETA ATRAS
                Transform.translate(
                  offset: Offset(0, 50 * _auxPercent!),
                  child: SuperheroCard(
                    superhero: heroes[_auxIndex.clamp(0, heroes.length - 1)],
                    factorChange: _auxPercent,
                  ),
                ),
                //tarjeta enfrentee
                Transform.translate(
                  offset: Offset(-800 * _percent!, 100 * _percent!),
                  child: Transform.rotate(
                    angle: angleRotate * _percent!,
                    child: SuperheroCard(
                      superhero: heroes[_index],
                      factorChange: _percent,
                    ),
                  ),
                )
              ],
            ),
          ),
          //pagina vista void
          PageView.builder(
            controller: _pageController,
            itemCount: heroes.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => _openDetail(context, heroes[index]),
                child: const SizedBox(),
              );
            },
          )
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, Superhero superhero) {
    Navigator.push(
      context,
      PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: SuperheroDetailPage(
              superhero: superhero,
            ),
          );
        },
      ),
    );
  }
}

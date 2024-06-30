import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'my_globals.dart' as globals;

class QuoteCard extends StatefulWidget {
  const QuoteCard({Key? key}) : super(key: key);

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _quote = globals.globalDefaultQuote;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    Timer.periodic(const Duration(seconds: 8), (timer) {
      fetchQuoteFromAPI();
    });
  }

  Future<void> fetchQuoteFromAPI() async {
    String quote = "";

    final response = await http.get(Uri.parse(globals.globalQuoteAPIUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      quote = data['content'];
    }
    _controller.forward(from: 0.0);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _quote = quote;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _animation.value * 3.14159; // Flip angle
          return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              child: angle < 3.14159 / 2
                  ? buildCard(_quote, context)
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(3.14159),
                      child: buildCard(_quote, context),
                    ));
        },
      ),
    );
  }

  Widget buildCard(String _quote, BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.80;

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: _width,
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.5), Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(4.0, 4.0),
              blurRadius: 10.0,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              offset: const Offset(-4.0, -4.0),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _quote,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                        blurRadius: 10.0,
                        color: Colors.black26,
                        offset: Offset(2.0, 2.0))
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

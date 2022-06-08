import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:news_graphql/screens/web_view_screen.dart';

class NewsDetailScreen extends StatelessWidget {
  final String urlToImage;
  final String author;
  final String content;
  final String publishedAt;
  final String description;
  final String url;
  final String source;
  final String title;

  NewsDetailScreen({
    this.title,
    this.urlToImage,
    this.author,
    this.content,
    this.publishedAt,
    this.description,
    this.url,
    this.source,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News Detail')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 250,
            child: Image.network(
              urlToImage,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Transform.translate(
              offset: const Offset(0, -30),
              child: Container(
                decoration:
                    const BoxDecoration(color: Color.fromARGB(90, 0, 0, 0)),
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: Text(
                  DateFormat('dd/MM/yy  kk:mm')
                      .format(DateTime.parse(publishedAt))
                      .toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: RichText(
              text: TextSpan(
                text: title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              description,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: content,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  TextSpan(
                    text: '  read more',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = (() {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => WebViewScreen(url: url),
                          ),
                        );
                      }),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Source: $author',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

import './screens/news_detail_screen.dart';

const newsGraphQl = """
query getNews {
  news {
    title
    url
    publishedAt
    author
    content
    description
    h_id
    source
    urlToImage
  }
}
""";

void main() {
  final HttpLink httpLink =
      HttpLink('https://comic-garfish-89.hasura.app/v1/graphql');
  ValueNotifier<GraphQLClient> client = ValueNotifier(GraphQLClient(
      link: httpLink, cache: GraphQLCache(store: InMemoryStore())));
  var app = GraphQLProvider(client: client, child: MyApp());

  runApp(app);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(221, 230, 228, 228),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('News'),
      ),
      body: Query(
        options: QueryOptions(document: gql(newsGraphQl)),
        builder: (QueryResult result, {fetchMore, refetch}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }
          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final newsList = result.data['news'];
          DateFormat dateFormat = DateFormat("yyyy-MM-dd");

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: newsList.length,
                  itemBuilder: (_, index) {
                    var news = newsList[index];
                    return GestureDetector(
                      onTap: (() {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NewsDetailScreen(
                              urlToImage: news['urlToImage'],
                              title: news['title'],
                              content: news['content'],
                              description: news['description'],
                              url: news['url'],
                              source: news['source'],
                              author: news['author'],
                              publishedAt: news['publishedAt'],
                            ),
                          ),
                        );
                      }),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10.0),
                                      child: Text(
                                        DateFormat('dd/MM/yy  kk:mm')
                                            .format(DateTime.parse(
                                                news['publishedAt']))
                                            .toString(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(news['title']),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(news['author']),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text('Source: ${news['source']}'),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(12.0),
                                width: 200,
                                height: 200,
                                child: Image.network(
                                  news['urlToImage'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

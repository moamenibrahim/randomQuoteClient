import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:random_quote/bloc/bloc.dart';
import 'package:random_quote/repositories/quote_api_client.dart';
import 'package:random_quote/repositories/repositories.dart';
import 'package:random_quote/views/home_page.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();

  final QuoteRepository repository = QuoteRepository(
    quoteApiClient: QuoteApiClient(
      httpClient: http.Client(),
    ),
  );

  runApp(MyApp(
    repository: repository,
  ));
}

class MyApp extends StatelessWidget {
  final QuoteRepository repository;

  MyApp({Key key, @required this.repository})
      : assert(repository != null),
        super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Quote'),
        ),
        body: BlocProvider(
          create: (context) => QuoteBloc(repository: repository),
          child: HomePage(),
        ),
      ),
    );
  }
}

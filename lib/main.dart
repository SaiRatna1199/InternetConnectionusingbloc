import 'package:blocpracticeapp/InternetBloc/internetbloc.dart';
import 'package:blocpracticeapp/InternetBloc/internetstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InternetBloc(),
      child: MaterialApp(
        title: 'Internet Connection',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(title: 'Check Internet Connection'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  checkConnectivity() async {
    bool result = await InternetConnection().hasInternetAccess;
    return result;
  }

  final listener =
      InternetConnection().onStatusChange.listen((InternetStatus status) {
    switch (status) {
      case InternetStatus.connected:
        // The internet is now connected
        break;
      case InternetStatus.disconnected:
        // The internet is now disconnected
        break;
    }
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: BlocConsumer<InternetBloc, InternetState>(
                listener: (context, state) {
                  if (state is InternetGainedState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Internet Connection is Live...!",
                          style: TextStyle(color: Colors.black),
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (state is InternetLostState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Lost Internet Connection...",
                          style: TextStyle(color: Colors.black),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is InternetGainedState) {
                    return Text(
                      "Connected to Internet",
                      textAlign: TextAlign.center,
                    );
                  } else if (state is InternetLostState) {
                    return Text(
                      "Not Connected to Internet",
                      textAlign: TextAlign.center,
                    );
                  } else {
                    return Text(
                      "Loading.....",
                      textAlign: TextAlign.center,
                    );
                  }
                },
              ),
            ),
            /*Center(
              child: BlocBuilder<InternetBloc, InternetState>(
                builder: (context, state) {
                  if (state is InternetGainedState) {
                    return Center(
                      child: Container(
                        height: 200,
                        width: 300,
                        child: Center(
                          child: Text(
                            "Connected",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  } else if (state is InternetLostState) {
                    return Center(
                      child: Container(
                        height: 200,
                        width: 300,
                        child: Center(
                          child: Text(
                            "Not Connected",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Container(
                        height: 200,
                        width: 300,
                        child: Center(
                          child: Text(
                            "Loading.....",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),*/
            /* Center(
              child: Container(
                height: 200,
                width: 300,
                child: Center(
                  child: Text(
                    "Loading...",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ),
      /*floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
        ],
      ), */
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'globals.dart' as globals;

import 'actor_model.dart';

import 'dart:developer' as dev;

void main() {
  runApp(MyApp());
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
      home: MyHomePage(title: 'FIT2095 S2 2020'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Future<Actor> creatActor(String name, int bYear) async {
  final String apiUrl = globals.serverURL + "/actors";
  print('We Start creating an actor');

  final response =
      await http.post(apiUrl, body: {"name": name, "bYear": bYear.toString()});
  print('post sent');
  print(response.statusCode);

  if (response.statusCode == 200) {
    print('we got 200');

    final String responseString = response.body;

    return actorFromJson(responseString);
  } else {
    print('post failed');

    return null;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bYearController = TextEditingController();

  int _counter = 0;
  final globalKey = GlobalKey<ScaffoldState>();

  Future<List<Actor>> getActorList() async {
    final String apiUrl = globals.serverURL + "/actors";
    final response = await http.get(apiUrl);
    print(response.body);
    Iterable l = json.decode(response.body);

    List<Actor> itemsList = List<Actor>.from(l.map((i) => Actor.fromJson(i)));

    return itemsList;
  }

  var actors = [];

  void _init() async {
    var list = await getActorList();
    setState(() {
      actors = list;
    });
  }

  _MyHomePageState() {
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                child: Form(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                              labelText: 'Fullname',
                              hintText: 'Enter the Actor Name',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)))),
                    ),
                    TextFormField(
                        controller: bYearController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            labelText: 'Actor Birth',
                            hintText: 'Entor the Actor Name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)))),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            String name = nameController.text;
                            int bYear = int.parse(bYearController.text + "");
                            print(name);
                            print(bYear);
                            Actor response = await creatActor(name, bYear);

                            var list = await getActorList();
                            setState(() {
                              actors = list;
                            });
                            globalKey.currentState.showSnackBar(SnackBar(
                                content: Text(response.id.toString())));
                          },
                          child: Text("Add Actor")),
                    ),
                  ],
                ))),
            new Expanded(
                child: ListView.builder(
              itemCount: actors.length,
              itemBuilder: (context, index) {
                return Card(
                    child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(actors[index].name),
                      Text(actors[index].bYear.toString())
                    ],
                  ),
                ));
              },
            ))
          ],
        ));
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PersonEquatable extends Equatable {
  final String name;
  final int age;

  const PersonEquatable({required this.name, required this.age});

  @override
  List<Object> get props => [name, age];
}

class PersonNormal {
  final String name;
  final int age;

  PersonNormal({required this.name, required this.age});
}

void main() {
  PersonNormal person1 = PersonNormal(name: 'John', age: 30);
  PersonNormal person2 = PersonNormal(name: 'John', age: 30);
  if (kDebugMode) {
    print('person1 == person2: ${person1 == person2}');
  }

  PersonEquatable person3 = const PersonEquatable(name: 'John', age: 30);
  PersonEquatable person4 = const PersonEquatable(name: 'John', age: 30);
  if (kDebugMode) {
    print('person3 == person4: ${person3 == person4}');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  final List<String> _list = [];
  static const platform = MethodChannel('flutter-channel');
  String _batteryLevel = 'Unknown battery level.';

  void _incrementCounter() {
    _counter++;
    setState(() {
      _list.add('$_counter');
    });
    print(_list);
  }

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final result = await platform.invokeMethod<int>('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<void> _openSetting() async {
    try {
      await platform.invokeMethod<int>('openSetting');
    } on PlatformException catch (e) {}
  }

  Future<void> _checkLocationPermission() async {
    try {
      final result =
          await platform.invokeMethod<int>('checkLocationPermission');
      print(result);
    } on PlatformException catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    print('------main widget------');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // const RenderText(),
            // RenderTextStateful(),
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headlineMedium,
            // ),
            // Column(
            //   children: _list.map((e) => Text(e)).toList(),
            // ),
            SizedBox(
                width: 200,
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // ElevatedButton(
                      //   onPressed: _getBatteryLevel,
                      //   child: const Text('Get Battery Level'),
                      // ),
                      // Text(_batteryLevel),
                      ElevatedButton(
                        onPressed: _openSetting,
                        child: const Text('Open Settings'),
                      ),
                      ElevatedButton(
                        onPressed: _checkLocationPermission,
                        child: const Text('Check location permission'),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //  renderText() {
  //   print('------renderText------');
  //   return const Text(
  //     'You have pushed the button this many times:',
  //   );
  // }
  // W
}

class RenderText extends StatelessWidget {
  const RenderText({super.key});

  @override
  Widget build(BuildContext context) {
    print('------RenderText------');
    return const Text(
      'You have pushed the button this many times:',
    );
  }
}

class RenderTextStateful extends StatefulWidget {
  const RenderTextStateful({super.key});

  @override
  State<RenderTextStateful> createState() => _RenderTextStatefulState();
}

class _RenderTextStatefulState extends State<RenderTextStateful> {
  String _text = 'kaka';
  @override
  Widget build(BuildContext context) {
    print('------RenderTextStateful------');
    return Column(children: [
      Text(_text),
      ElevatedButton(
          onPressed: () {
            setState(() {
              _text = _text + 'hello';
            });
          },
          child: const Text('click'))
    ]);
  }
}

import 'package:flutter/material.dart';
import 'package:music_notes/core/lesson.dart';
import 'package:music_notes/screens/start_screen.dart';
import 'package:music_notes/widgets/keyboard.dart';
import 'package:music_notes/widgets/staff.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Piano Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: const StartScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    this.clefType = ClefType.treble,
  });

  final String title;
  final ClefType clefType;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _selectedNote = 'C';
  late Lesson lesson;
  Color _backgroundColor = const Color.fromARGB(255, 255, 247, 228);

  @override
  void initState() {
    super.initState();
    lesson = Lesson('C', clefType: widget.clefType);
  }

  void _onKeyPressed(String note) {
    setState(() {
      if (note == lesson.currentNote) {
        _selectedNote = lesson.getNextNote();
        _backgroundColor = Color.fromARGB(255, 255, 247, 228);
      } else {
        _backgroundColor = const Color.fromARGB(255, 129, 9, 0);
      }
    });
    debugPrint('Pressed $note');
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      backgroundColor: _backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
              'Selected Note: $_selectedNote',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            MusicalStaff(note: _selectedNote, clefType: widget.clefType),
            const SizedBox(height: 40),
            PianoKeyboard(
              onKeyPressed: _onKeyPressed,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

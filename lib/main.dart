import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adoption and Travel Planner',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Adoption and Travel Planner'),
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
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _desccontroller = TextEditingController();
  final TextEditingController _datecontroller = TextEditingController();
  List<String> planList = [];

  void _updateMyItems(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final plan = planList.removeAt(oldIndex);
    planList.insert(newIndex, plan);
  }

  void _addPlan() {
    String name = _namecontroller.text;
    String desc = _desccontroller.text;
    String date = _datecontroller.text;
    setState(() {
      planList.add(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[200]!,
        title: Text(widget.title, style: GoogleFonts.outfit()),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: () => _dialogBuilder(context, _namecontroller,
                    _desccontroller, _datecontroller, _addPlan),
                child: Text('Create Plan'),
              ),
              Expanded(
                  child: ReorderableListView.builder(
                itemCount: planList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      key: ValueKey(index), title: Text(planList[index]));
                },
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    _updateMyItems(oldIndex, newIndex);
                  });
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _dialogBuilder(
    BuildContext context,
    TextEditingController namecontroller,
    TextEditingController desccontroller,
    TextEditingController datecontroller,
    VoidCallback addPlanCallback) {
  return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text('Create Plan'),
            content: SingleChildScrollView(
              child: Column(children: [
                TextField(
                    controller: namecontroller,
                    decoration: InputDecoration(hintText: 'Enter plan name')),
                TextField(
                    controller: desccontroller,
                    decoration:
                        InputDecoration(hintText: 'Enter plan description')),
                TextField(
                    controller: datecontroller,
                    decoration: InputDecoration(hintText: 'Enter plan date')),
              ]),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  addPlanCallback();
                  Navigator.of(context).pop();
                },
              )
            ]);
      });
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

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
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final plan = planList.removeAt(oldIndex);
      planList.insert(newIndex, plan);
    });
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
      bottomNavigationBar: Container(
          height: 60,
          decoration: BoxDecoration(
              color: Colors.teal[200]!,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            IconButton(
              onPressed: () {
                // nothing happens, already on homepage
              },
              icon: const Icon(
                Icons.home_outlined, // homepage
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CalendarPage()));
              },
              icon: const Icon(
                Icons.calendar_month, // calendar page
                color: Colors.white,
              ),
            ),
          ])),
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
                      key: ValueKey(planList[index]),
                      title: Text(planList[index]));
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

// Calendar Page
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPage();
}

class _CalendarPage extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal[200]!,
          title: Text("Calendar", style: GoogleFonts.outfit()),
          centerTitle: true,
        ),
        body: Center(
            child: TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: DateTime.now(),
        )));
  }
}

// Dialog for creating plan
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

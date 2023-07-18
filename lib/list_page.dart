import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPage extends StatefulWidget {
  final ValueNotifier<double> totalExpenseNotifier;

  ListPage({required this.totalExpenseNotifier});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Entry> entries = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadExpenseLogs();
  }

  void loadExpenseLogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? expenseList = prefs.getStringList('expenseLogs');
    if (expenseList != null) {
      setState(() {
        entries = expenseList.map((expense) {
          List<String> data = expense.split(',');
          return Entry(name: data[0], value: double.parse(data[1]));
        }).toList();
      });
    }
  }

  void saveExpenseLogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> expenseList = entries.map((entry) {
      return '${entry.name},${entry.value}';
    }).toList();
    await prefs.setStringList('expenseLogs', expenseList);
  }

  void addEntry() {
    String name = nameController.text;
    double value = double.parse(valueController.text);
    Entry entry = Entry(name: name, value: value);
    setState(() {
      entries.add(entry);
    });
    nameController.clear();
    valueController.clear();
    saveExpenseLogs();
    widget.totalExpenseNotifier.value = getTotalValue();
    Navigator.of(context).pop(); // Close the dialog after adding the entry
  }

  void deleteEntry(int index) {
    setState(() {
      entries.removeAt(index);
    });
    saveExpenseLogs();
    widget.totalExpenseNotifier.value = getTotalValue();
  }

  double getTotalValue() {
    double total = 0;
    for (Entry entry in entries) {
      total += entry.value;
    }
    return total;
  }

  void showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Expense"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: valueController,
                decoration: InputDecoration(labelText: "Value"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Add"),
              onPressed: addEntry,
            ),
            ElevatedButton(
              child: Text("Cancel"),
              onPressed: () {
                nameController.clear();
                valueController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(entries[index].name),
                  subtitle: Text(entries[index].value.toString()),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteEntry(index),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Total Value: ${getTotalValue().toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            child: Text("Add Expense"),
            onPressed: showAddExpenseDialog,
          ),
        ],
      ),
    );
  }
}

class Entry {
  final String name;
  final double value;

  Entry({required this.name, required this.value});
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier<double> totalExpenseNotifier = ValueNotifier<double>(0.0);

  void navigateToListPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListPage(totalExpenseNotifier: totalExpenseNotifier),
      ),
    ).then((value) {
      setState(() {
        double totalExpense = totalExpenseNotifier.value;
        // Do something with the updated total expense value
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total Expense: ${totalExpenseNotifier.value.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              child: Text('Go to List Page'),
              onPressed: navigateToListPage,
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

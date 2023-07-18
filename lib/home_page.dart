import 'package:flutter/material.dart';
import 'list_page.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
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
        // Do something with the updated total expense value if needed
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Track your expenses',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.network(
              'http://cdn.onlinewebfonts.com/svg/img_183066.png',
              // Replace with your image URL
              width: 100.0,
              height: 100.0,
            ),
            const Text(
              'Welcome Back!!',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            ValueListenableBuilder<double>(
              valueListenable: totalExpenseNotifier,
              builder: (context, value, child) {
                return Text(
                  'Total: \$${value.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                );
              },
            ),
            ElevatedButton(
              child: const Text("Show Expenses"),
              onPressed: navigateToListPage,
            ),
          ],
        ),
      ),
    );
  }
}

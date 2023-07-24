import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class ExpenseEntry {
  final String category;
  final double price;
  ExpenseEntry(this.category, this.price);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Tracker',
      theme: ThemeData(
        primarySwatch: Colors.purple, // Change the primary color of the app
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  String category = '';
  double price = 0.0;

  double calculateTotal() {
    double total = 0.0;
    for (var entry in entries) {
      total += entry.price;
    }
    return total;
  }

  void navigateToExpenses(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExpensesScreen()),
    );
  }

  void showAddExpensePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Text(
            'New Entry',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
          ),
          content: Container(
            width: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  onChanged: (value) {
                    category = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Category',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  onChanged: (value) {
                    price = double.tryParse(value) ?? 0.0;
                  },
                  decoration: InputDecoration(
                    hintText: 'Price',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                onPressed: () {
                  if (category != null && price != null && price > 0) {
                    Navigator.pop(context, ExpenseEntry(category, price));
                  }
                },
                icon: Icon(Icons.check),
                iconSize: 40,
                color: Colors.deepPurple,
              ),
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null) {
        entries.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Color.fromARGB(
                255, 197, 132, 250), // Change the background color here
            padding: EdgeInsets.only(top: 40, left: 18, right: 43),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.deepPurple,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 8),
                Text(
                  'Budget Tracker',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Color.fromARGB(
                  255, 197, 132, 250), // Change the background color here
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Icon(
                        Icons.person,
                        size: 200,
                      ),
                    ),
                    Text(
                      'Welcome',
                      style: TextStyle(
                          fontSize: 48,
                          fontFamily: 'MyCustomFont',
                          letterSpacing: 1.0),
                    ),
                    Text(
                      'Back!',
                      style: TextStyle(
                          fontSize: 48,
                          fontFamily: 'MyCustomFont',
                          letterSpacing: 1.0),
                    ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 40),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.attach_money),
                              SizedBox(width: 8),
                              Text(
                                'Total:  ${calculateTotal().toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          child: IconButton(
                            icon:
                            Icon(Icons.keyboard_double_arrow_down_outlined),
                            onPressed: () => navigateToExpenses(context),
                            color: Colors.deepPurple,
                            iconSize: 30,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddExpensePopup(context),
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepPurple,
        child: Icon(Icons.add, size: 40),
      ),
    );
  }
}

List<ExpenseEntry> entries = [];

class ExpensesScreen extends StatelessWidget {
  String category = '';
  double price = 0.0;

  void deleteEntry(ExpenseEntry entry) {
    entries.remove(entry);
  }

  double calculateTotal() {
    double total = 0.0;
    for (var entry in entries) {
      total += entry.price;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Color.fromARGB(
                255, 197, 132, 250), // Change the background color here
            padding: EdgeInsets.only(top: 40, left: 18, right: 43),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.deepPurple,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 8),
                Text(
                  'Budget Tracker',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Color.fromARGB(
                  255, 197, 132, 250), // Change the background color here
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 80),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 40),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.attach_money),
                              SizedBox(width: 8),
                              Text(
                                'Total:  ${calculateTotal().toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: entries.length,
                        itemBuilder: (context, index) {
                          return ExpenseCard(entries[index], () {
                            deleteEntry(entries[index]);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExpensePopup(context),
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepPurple,
        child: Icon(Icons.add, size: 40),
      ),
    );
  }

  void _showAddExpensePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Text(
            'New Entry',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          content: Container(
            width: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  onChanged: (value) {
                    category = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Category',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  onChanged: (value) {
                    price = double.tryParse(value) ?? 0.0;
                  },
                  decoration: InputDecoration(
                    hintText: 'Price',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                onPressed: () {
                  if (category != null && price != null && price > 0) {
                    Navigator.pop(context, ExpenseEntry(category, price));
                  }
                },
                icon: Icon(Icons.check),
                iconSize: 40,
                color: Colors.deepPurple,
              ),
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null) {
        entries.add(value);
      }
    });
  }
}

class ExpenseCard extends StatelessWidget {
  final ExpenseEntry entry;
  final Function onDelete;
  ExpenseCard(this.entry, this.onDelete);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 300,
          child: Card(
            color: const Color.fromARGB(255, 245, 244, 243),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.category,
                    style: TextStyle(
                      color: Colors.purpleAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    '\ ${entry.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.deepPurple,
          ),
          child: IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () {
              onDelete();
            },
            iconSize: 35,
            color: Color.fromARGB(255, 234, 156, 248),
          ),
        ),
      ],
    );
  }
}

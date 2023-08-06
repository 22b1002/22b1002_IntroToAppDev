import 'package:asssignment_3/pages/login_register_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:asssignment_3/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';




class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('Firebase Auth');
  }

  Widget _userUid(){
    return Text(user?.email ?? 'User email'); 
  }

  Widget _signOutButton(){
    return ElevatedButton(
      onPressed: signOut, 
      child: const Text('Sign Out'),
      );
  }

 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Change the primary color of the app
      ),
      home: HomeScreen(),
    );
  }
}
class ExpenseEntry {
  final String category;
  final double price;
  final String currency;
  ExpenseEntry(this.category, this.price,this.currency);
}

class HomeScreen extends StatelessWidget {
  String category = '';
  double price = 0.0;
  String currency ='USD';


  double calculateTotal() {
    double total = 0.0;
    for (var entry in entries) {
      total += entry.price;
    }
    return total;
  }
  

 void navigateToExpenses(BuildContext context)  {
    // Fetch expense entries from Firestore
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
          backgroundColor: Colors.blue,
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
          SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: currency,
                  onChanged: (value) {
                    currency = value!;
                  },
                  items: ['USD', 'EUR', 'GBP', 'JPY', 'INR'] // Add other currency options if needed
                      .map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
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
                    Navigator.pop(context, ExpenseEntry(category, price,currency));
                  }
                },
                icon: Icon(Icons.check),
                iconSize: 40,
                color: Colors.blue,
              ),
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null) {
        String? userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId != null) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('expenses')
              .add({
            'category': value.category,
            'price': value.price,
            'currency':value.currency,
          });
        }
      }
    });
  }
    

  void showEditExpensePopup(BuildContext context, ExpenseEntry entry) {
    category = entry.category;
    price = entry.price;
    currency = entry.currency;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue,
          title: Text(
            'Edit Entry',
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
                  initialValue: category,
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
                  initialValue: price.toString(),
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
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: currency,
                  onChanged: (value) {
                    currency = value!;
                  },
                  items: ['USD', 'EUR', 'GBP', 'JPY', 'INR'] // Add other currency options if needed
                      .map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
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
                    // Find the index of the edited entry in the list
                    int index = entries.indexOf(entry);

                    // Update the entry at the specific index
                    entries[index] = ExpenseEntry(category, price,currency);

                    Navigator.pop(context);
                  }
                },
                icon: Icon(Icons.check),
                iconSize: 40,
                color: Colors.blue,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Color.fromARGB(255, 132, 216, 250), // Change the background color here
            padding: EdgeInsets.only(top: 40, left: 18, right: 43),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Text(
                  'Budget Tracker',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
               IconButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.white),
                ),
                  onPressed: ()async{
                   await Auth().signOut();
                   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>LoginPage(),));
                  }, icon: Icon(Icons.person,
                  size: 30,)),
                  Text('Sign Out',
                   style: TextStyle(fontSize: 11,color: Colors.black ) , ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color:  Color.fromARGB(255, 132, 216, 250), // Change the background color here
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
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Reserves',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 6),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          child: IconButton(
                            icon: Icon(Icons.keyboard_double_arrow_down_outlined),
                            onPressed: () => navigateToExpenses(context),
                            color: Colors.blue,
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
        foregroundColor: Colors.blue,
        child: Icon(Icons.add, size: 40),
      ),
    );
  }
}

List<ExpenseEntry> entries = [];

class ExpensesScreen extends StatelessWidget {
  String category = '';
  double price = 0.0;
  String currency = 'USD';
  List<ExpenseEntry> entries = [];

  

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

   Stream<List<ExpenseEntry>> getExpenseEntriesStream() {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return ExpenseEntry(data['category'], data['price'],data['currency']);
        }).toList();
      });
    } else {
      return Stream.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ExpenseEntry>>(
      stream: getExpenseEntriesStream(),
      builder:(context,snapshot){
        if (snapshot.hasData) {
          entries = snapshot.data!;
      
    return Scaffold(
      body: Column(
        children: [
          Container(
            color:  Color.fromARGB(255, 132, 216, 250), // Change the background color here
            padding: EdgeInsets.only(top: 40, left: 18, right: 43),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                
                Text(
                  'Budget Tracker',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                IconButton(
                  onPressed: ()async{
                   await Auth().signOut();
                   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>LoginPage(),));
                  }, icon: Icon(Icons.person,
                  size: 30,)),
                  Text('Sign Out',
                   style: TextStyle(fontSize: 10,color: Colors.black ) , ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Color.fromARGB(255, 132, 216, 250), // Change the background color here
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
                          child: Text(
                            'Total:  ${calculateTotal().toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
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
                          }, () {
                            showEditExpensePopup(context, entries[index]);
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
        foregroundColor: Colors.blue,
        child: Icon(Icons.add, size: 40),
      ),
    );
  } else if (snapshot.hasError) {
    return Center(
      child: Text('Error: ${snapshot.error}'),
    );
  }else {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
  },
    );
  }

  void _showAddExpensePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue,
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
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: currency,
                  onChanged: (value) {
                    currency = value!;
                  },
                  items: ['USD', 'EUR', 'GBP', 'JPY', 'INR'] // Add other currency options if needed
                      .map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
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
                  if (price != 0) {
                    Navigator.pop(context, ExpenseEntry(category, price,currency));
                  }
                },
                icon: Icon(Icons.check),
                iconSize: 40,
                color: Colors.blue,
              ),
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null) {
        String? userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId != null) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('expenses')
              .add({
            'category': value.category,
            'price': value.price,
            'currency': value.currency,
          });
        }
      }
    });
  }
    
  
  void showEditExpensePopup(BuildContext context, ExpenseEntry entry) {
  category = entry.category;
  price = entry.price;
  currency = entry.currency;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.blue,
        title: Text(
          'Edit Entry',
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
                initialValue: category,
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
                initialValue: price.toString(),
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
              SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: currency,
                  onChanged: (value) {
                    currency = value!;
                  },
                  items: ['USD', 'EUR', 'GBP', 'JPY', 'INR'] // Add other currency options if needed
                      .map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
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
                if (price > 0) {
                  // Find the index of the edited entry in the list
                  int index = entries.indexOf(entry);

                  // Update the entry at the specific index
                  entries[index] = ExpenseEntry(category, price,currency);

                  Navigator.pop(context);
                }
              },
              icon: Icon(Icons.check),
              iconSize: 40,
              color: Colors.blue,
            ),
          ),
        ],
      );
    },
  );
}
}

class ExpenseCard extends StatelessWidget {
  final ExpenseEntry entry;
  final Function onDelete;
  final Function() onEdit;

  ExpenseCard(this.entry, this.onDelete, this.onEdit);

  Future<void> deleteEntry(BuildContext context) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('expenses')
            .where('category', isEqualTo: entry.category)
            .where('price', isEqualTo: entry.price)
            .get()
            .then((snapshot) {
          snapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });
      }
      onDelete();
    } catch (e) {
      print('Error deleting entry: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(entry.category), // Specify a unique key for each item
      onDismissed: (direction) {
        // Call the onDelete function when the item is dismissed (deleted)
        onDelete();
      },
      background: Container(
        color: Colors.black, // Background color when sliding to delete
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
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
              color: Colors.blue,
            ),
            
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                onEdit();
              },
              iconSize: 35,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: 'Budget Tracker',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: HomePage(),
    routes: {
      '/expenses': (context) => ExpensesScreen(),
    },
  ));
}
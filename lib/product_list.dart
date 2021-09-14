import 'package:fire_app/cart.dart';
import 'package:fire_app/cart_provider_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  CollectionReference _productss =
      FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kindacode.com'),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => CartList())),
              icon: Icon(Icons.shopping_cart_rounded))
        ],
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: StreamBuilder(
        stream: _productss.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                final item = Item(
                    id: documentSnapshot.id.toString(),
                    name: documentSnapshot['name'],
                    price: documentSnapshot['price']);

                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['name']),
                    subtitle: Text(documentSnapshot['price'].toString()),
                    trailing: SizedBox(
                      width: 150,
                      child: Row(
                        children: [
                          // Press this button to edit a single product
                          IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),
                          // This icon button is used to delete a single product
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteProduct(documentSnapshot.id)),
                          Consumer<CartModel>(
                            builder: (context, cart, child) {
                              final checked = cart.getItems
                                      .where((element) =>
                                          element.id == documentSnapshot.id)
                                      .toString() !=
                                  "()";
                              return Checkbox(
                                  value: checked,
                                  onChanged: (val) {
                                    if (val == true)
                                      cart.add(item);
                                    else
                                      cart.remove(item);
                                  });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // Add new product
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: Icon(Icons.add),
      ),
    );
  }

  // This function is triggered when the floatting button or one of the edit buttons is pressed
  // Adding a product if no documentSnapshot is passed
  // If documentSnapshot != null then update an existing product
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _nameController.text = documentSnapshot['name'];
      _priceController.text = documentSnapshot['price'].toString();
    }

    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            content: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: 'Price',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: Text(action == 'create' ? 'Create' : 'Update'),
                    onPressed: () async {
                      final String? name = _nameController.text;
                      final double? price =
                          double.tryParse(_priceController.text);
                      if (name != null && price != null) {
                        if (action == 'create') {
                          // Persist a new product to Firestore
                          await _productss.add({"name": name, "price": price});
                        }

                        if (action == 'update') {
                          // Update the product
                          await _productss
                              .doc(documentSnapshot!.id)
                              .update({"name": name, "price": price});
                        }

                        // Clear the text fields
                        _nameController.text = '';
                        _priceController.text = '';

                        // Hide the bottom sheet
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  // Deleteing a product by id
  Future<void> _deleteProduct(String productId) async {
    await _productss.doc(productId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You have successfully deleted a product')));
  }
}

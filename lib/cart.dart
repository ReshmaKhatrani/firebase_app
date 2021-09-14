import 'package:fire_app/cart_provider_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartList extends StatelessWidget {
  const CartList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartModel>(
      builder: (context, cart, child) => Scaffold(
        appBar: AppBar(
          title: Text('Cart'),
          actions: [
            Center(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Total: ${cart.totalPrice}")),
            ),
          ],
        ),
        body: ListView.builder(
            itemCount: cart.getItems.length,
            itemBuilder: (context, index) => ListTile(
                  title: Text("${cart.getItems[index].name}"),
                )),
      ),
      child: Text(''),
    );
  }
}

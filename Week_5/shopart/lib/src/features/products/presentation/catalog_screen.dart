import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopart/model/product.dart';
import 'package:shopart/src/features/cart/presentation/cart_controller.dart';
import 'package:shopart/src/features/cart/presentation/cart_screen.dart';

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    

    final List<Product> items = [
      Product(
        id: "1", 
        title: "Mona Lisa", 
        price: 99.99, 
        color: Colors.red
        ),
      Product(
        id: "2",
        title: "Starry Night",
        price: 149.99,
        color: Colors.blue
      ),
      Product(
        id: "3",
        title: "The Scream",
        price: 129.99,
        color: Colors.yellow
      ),
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Catalog"),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const CartScreen()));
          }, icon: Icon(Icons.shopping_cart))
        ],
      ),

      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index){
          final item = items[index];
          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              color: item.color,

            ),
            title: Text(item.title),
            subtitle: Text("\$${item.price}"),
            trailing: ElevatedButton(onPressed: (){ref.read(cartProvider.notifier).addToCart(item);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("${item.title} added to cart"),
              duration: Duration(seconds: 1)
              )
            );
            }, 
            child: Text("Add to Cart")),
          );
        }
        )
    );
  }
}
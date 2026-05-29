import 'package:flutter/material.dart';
import 'product_model.dart';
import 'api_service.dart';

void main() => runApp(MaterialApp(home: CRUDApp()));

class CRUDApp extends StatefulWidget {
  @override
  _CRUDAppState createState() => _CRUDAppState();
}

class _CRUDAppState extends State<CRUDApp> {
  final ApiService apiService = ApiService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  // Dialog box to Add or Edit
  void showProductDialog(Product? product) {
    if (product != null) {
      nameController.text = product.name;
      priceController.text = product.price;
    } else {
      nameController.clear();
      priceController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product == null ? "Add Product" : "Edit Product"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: InputDecoration(hintText: "Name")),
            TextField(controller: priceController, decoration: InputDecoration(hintText: "Price")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (product == null) {
                await apiService.addProduct(nameController.text, priceController.text);
              } else {
                await apiService.updateProduct(product.id!, nameController.text, priceController.text);
              }
              setState(() {}); // Refresh UI
              Navigator.pop(context);
            },
            child: Text("Save"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Laravel Flutter CRUD")),
      body: FutureBuilder<List<Product>>(
        future: apiService.getProducts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Product item = snapshot.data![index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text("Rs. ${item.price}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: Icon(Icons.edit), onPressed: () => showProductDialog(item)),
                    IconButton(icon: Icon(Icons.delete, color: Colors.red), 
                      onPressed: () async {
                        await apiService.deleteProduct(item.id!);
                        setState(() {});
                      }),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showProductDialog(null),
      ),
    );
  }
}
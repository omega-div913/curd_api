import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product_model.dart';

class ApiService {
  
  final String baseUrl = "http://127.0.0.1:8000/api/products";

  // 1. READ (Get All Products)
  Future<List<Product>> getProducts() async {
    print("--- [GET] Fetching products from Laravel... ---");
    try {
      final response = await http.get(Uri.parse(baseUrl));
      
      print("Status Code: ${response.statusCode}");
      
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        print("Success: ${data.length} products found.");
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        print("Error: Server returned ${response.statusCode}");
        throw Exception("Failed to load products");
      }
    } catch (e) {
      print("Connection Error: $e");
      return [];
    }
  }

  // 2. CREATE (Add New Product)
  Future<void> addProduct(String name, String price) async {
    print("--- [POST] Sending data to Laravel: Name: $name, Price: $price ---");
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {'name': name, 'price': price},
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("LOG: Success! Data stored in MySQL database.");
      } else {
        print("LOG: Failed to store data. Check Laravel Model/Controller.");
      }
    } catch (e) {
      print("Connection Error: $e");
    }
  }

  // 3. UPDATE (Edit Product)
  Future<void> updateProduct(int id, String name, String price) async {
    print("--- [PUT] Updating Product ID: $id ---");
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/$id"),
        body: {'name': name, 'price': price},
      );

      print("Status Code: ${response.statusCode}");
      
      if (response.statusCode == 200) {
        print("LOG: Product ID $id updated successfully.");
      } else {
        print("LOG: Update failed. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Connection Error: $e");
    }
  }

  // 4. DELETE (Remove Product)
  Future<void> deleteProduct(int id) async {
    print("--- [DELETE] Removing Product ID: $id ---");
    try {
      final response = await http.delete(Uri.parse("$baseUrl/$id"));

      print("Status Code: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 204) {
        print("LOG: Product ID $id deleted from database.");
      } else {
        print("LOG: Delete failed. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Connection Error: $e");
    }
  }
}
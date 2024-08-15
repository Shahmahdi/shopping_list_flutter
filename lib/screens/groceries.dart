import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list_app/configs/config.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/screens/new_item.dart';
import 'package:http/http.dart' as http;

class Groceries extends StatefulWidget {
  const Groceries({super.key});

  @override
  State<Groceries> createState() {
    return _Groceries();
  }
}

class _Groceries extends State<Groceries> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    try {
      final url = Uri.https(baseUrl, "${firebaseTables['shopping_list']}.json");
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        setState(() {
          _error = "Failed to fetch data. Please try again later.";
        });
      }
      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final listData = json.decode(response.body);
      List<GroceryItem> loadedItems = [];
      for (final item in listData.entries) {
        final category = categories.entries.firstWhere((catItem) {
          return catItem.value.title == item.value['category'];
        }).value;
        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
      }
      setState(() {
        _groceryItems = loadedItems;
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (ctx) {
        return const NewItem();
      }),
    );
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });
    final url = Uri.https(
      baseUrl,
      "${firebaseTables['shopping_list']}/${item.id}.json",
    );
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _error != null
              ? Center(
                  child: Text(_error!),
                )
              : _groceryItems.isEmpty
                  ? const Center(
                      child: Text("No item selected"),
                    )
                  : ListView.builder(
                      itemCount: _groceryItems.length,
                      itemBuilder: (context, index) => Dismissible(
                        onDismissed: (direction) {
                          _removeItem(_groceryItems[index]);
                        },
                        key: ValueKey(_groceryItems[index].id),
                        child: ListTile(
                          title: Text(_groceryItems[index].name),
                          leading: Container(
                            width: 24,
                            height: 24,
                            color: _groceryItems[index].category.color,
                          ),
                          trailing:
                              Text(_groceryItems[index].quantity.toString()),
                        ),
                      ),
                    ),
    );
  }
}

// ---------------------------------Alternative UI solution--------------------

// class _Groceries extends State<Groceries> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: groceryItems.length,
//       itemBuilder: (context, index) => Padding(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 12,
//           vertical: 8,
//         ),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Container(
//                   width: 24,
//                   height: 24,
//                   color: groceryItems[index].category.color,
//                 ),
//                 const SizedBox(width: 15),
//                 Expanded(
//                   child: Row(
//                     children: [
//                       Text(groceryItems[index].name),
//                       const Expanded(child: SizedBox()),
//                       Text(groceryItems[index].quantity.toString()),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

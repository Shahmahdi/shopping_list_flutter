import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/screens/new_item.dart';

class Groceries extends StatefulWidget {
  const Groceries({super.key});

  @override
  State<Groceries> createState() {
    return _Groceries();
  }
}

class _Groceries extends State<Groceries> {
  final _groceryItems = [];

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

  void _removeItem(GroceryItem item) {
    setState(() {
      _groceryItems.remove(item);
    });
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
      body: _groceryItems.isEmpty
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
                  trailing: Text(_groceryItems[index].quantity.toString()),
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

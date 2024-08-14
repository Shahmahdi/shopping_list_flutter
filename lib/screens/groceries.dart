import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/dummy_items.dart';
import 'package:shopping_list_app/screens/new_item.dart';

class Groceries extends StatefulWidget {
  const Groceries({super.key});

  @override
  State<Groceries> createState() {
    return _Groceries();
  }
}

class _Groceries extends State<Groceries> {
  void _addItem() {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return const NewItem();
    }));
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
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(groceryItems[index].name),
          leading: Container(
            width: 24,
            height: 24,
            color: groceryItems[index].category.color,
          ),
          trailing: Text(groceryItems[index].quantity.toString()),
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

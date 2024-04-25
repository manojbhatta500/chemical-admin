import 'package:apiadmin/pages/sidebar_pages/add_category.dart';
import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  final List<String> categories = [
    'Category 1',
    'Category 2',
    'Category 3',
    'Category 4',
    'Category 5',
    'Category 6',
    'Category 7',
    'Category 8',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddCategory()));
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(categories[index]),
            onTap: () {
              // Navigate to category details screen or perform other actions
            },
          );
        },
      ),
    );
  }
}

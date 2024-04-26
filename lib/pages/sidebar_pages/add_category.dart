import 'dart:developer';

import 'package:apiadmin/blocs/create_category/create_catogery_bloc.dart';
import 'package:apiadmin/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCategory extends StatelessWidget {
  final TextEditingController _categoryNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Category'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.2 * width),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _categoryNameController,
              decoration: InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            BlocListener<CreateCatogeryBloc, CreateCatogeryState>(
              listener: (context, state) {
                switch (state.runtimeType) {
                  case CreateCatogeryFailed:
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Unable to Create Category.')));
                  case CreateCatogeryLoading:
                    log('this is loading state');

                  case CreateCatogerySuccess:
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));

                  default:
                    log('this is default state');
                }
              },
              child: ElevatedButton(
                onPressed: () {
                  //
                  BlocProvider.of<CreateCatogeryBloc>(context).add(
                      CreateCategory(
                          categoryName: _categoryNameController.text));
                },
                child: Text('Create'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

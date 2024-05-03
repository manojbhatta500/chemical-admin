import 'dart:developer';

import 'package:apiadmin/blocs/fetch_category/fetch_category_cubit.dart';
import 'package:apiadmin/pages/sidebar_pages/add_category.dart';
import 'package:apiadmin/utils/deletebutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Categories extends StatefulWidget {
  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  void initState() {
    BlocProvider.of<FetchCategoryCubit>(context).changeFetchCategoryState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chemical Categories'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddCategory()));
        },
        child: Icon(Icons.add),
      ),
      body: BlocBuilder<FetchCategoryCubit, FetchCategoryState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case FetchCategoryLoading:
              return Center(
                child: CircularProgressIndicator(),
              );
            case FetchCategoryFailed:
              return Center(
                child: Text('Failed to fetch data'),
              );
            case FetchCategorySuccess:
              final data = state as FetchCategorySuccess;
              if (data.categorydata.length > 0) {
                return ListView.builder(
                  itemCount: data.categorydata.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(data.categorydata[index].name.toString()),
                        trailing: DeleteButton(
                          id: data.categorydata[index].id!,
                        ),
                        onTap: () {
                          log('Pressed ${data.categorydata[index].name.toString()}');
                        },
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text("No categories found in server."),
                );
              }

            default:
              // Handle the default case by returning a widget or null
              return Center(
                child: Text('Unhandled state: $state'),
              );
          }
        },
      ),
    );
  }
}

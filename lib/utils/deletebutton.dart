import 'package:apiadmin/blocs/delete_category/delete_category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteButton extends StatelessWidget {
  DeleteButton({super.key, required this.id});

  String id;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          BlocProvider.of<DeleteCategoryCubit>(context).deleteCategorycubit(id);
        },
        icon: Icon(Icons.delete));
  }
}

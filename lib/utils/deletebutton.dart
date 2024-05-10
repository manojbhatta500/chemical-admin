import 'package:apiadmin/blocs/delete_category/delete_category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Are you sure want to delete?"),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Text("No"),
                  ),
                  IconButton(
                    onPressed: () {
                      BlocProvider.of<DeleteCategoryCubit>(context)
                          .deleteCategorycubit(id);
                    },
                    icon: const Text("Yes"),
                  ),
                ],
              );
            });
        //BlocProvider.of<DeleteCategoryCubit>(context).deleteCategorycubit(id);
      },
      icon: const Icon(
        Icons.delete,
        color: Colors.red,
      ),
    );
  }
}

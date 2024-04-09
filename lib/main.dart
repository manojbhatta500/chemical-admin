import 'package:apiadmin/bloc/post_chemical_data_bloc.dart';
import 'package:apiadmin/pages/add_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostChemicalDataBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AddDataScreen(),
      ),
    );
  }
}

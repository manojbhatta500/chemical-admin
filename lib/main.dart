import 'package:apiadmin/blocs/create_category/create_catogery_bloc.dart';
import 'package:apiadmin/blocs/fetch_category/fetch_category_cubit.dart';
import 'package:apiadmin/blocs/signin/sign_in_bloc.dart';
import 'package:apiadmin/pages/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignInBloc(),
        ),
        BlocProvider(
          create: (context) => FetchCategoryCubit(),
        ),
        BlocProvider(
          create: (context) => CreateCatogeryBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SignInScreen(),
      ),
    );
  }
}

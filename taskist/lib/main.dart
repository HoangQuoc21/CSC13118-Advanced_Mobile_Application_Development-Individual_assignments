import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'providers/todo_provider.dart';
import 'package:taskist/ui/my_app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TodoProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

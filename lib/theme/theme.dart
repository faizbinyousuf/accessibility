import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData highContrastTheme = ThemeData(
    primaryColor: Colors.black,
    colorScheme: const ColorScheme.dark(
      primary: Colors.black,
      secondary: Colors.yellow,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      foregroundColor: Colors.yellow,
      color: Colors.black,
      titleTextStyle: TextStyle(
        color: Colors.yellow,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.yellow,
      ),
    ),
    brightness: Brightness.dark,
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: Colors.yellow,
        backgroundColor: Colors.black,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.yellow,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
        color: Colors.black,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
        color: Colors.black,
      )),
      hintStyle: TextStyle(
        color: Colors.black,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.yellow,
      ),
    ),
    listTileTheme: const ListTileThemeData(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.yellow,
          ),
        ),
        iconColor: Colors.yellow,

        // textColor: Colors.black,
        tileColor: Colors.black,
        titleTextStyle: TextStyle(
          color: Colors.yellow,
        ),
        subtitleTextStyle: TextStyle(
          color: Colors.yellow,
        )),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: Colors.yellow,
    )),
    fontFamily: 'Poppins',
  );

  static final normalTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: false,
      fontFamily: 'Poppins',
      listTileTheme: const ListTileThemeData(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.black,
            ),
          ),
          iconColor: Colors.black,
          textColor: Colors.black,
          titleTextStyle: TextStyle(
            color: Colors.black,
          ),
          subtitleTextStyle: TextStyle(
            color: Colors.black,
          )));
}

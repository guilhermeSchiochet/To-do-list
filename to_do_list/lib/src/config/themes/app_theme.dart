import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      cardColor: Colors.white,
      primaryColor: primaryColor,
      splashColor: Colors.transparent,
      scaffoldBackgroundColor: Color.fromRGBO(242, 242, 248, 1),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color.fromRGBO(242, 242, 248, 1),
      ),
      fontFamily: 'IBM',
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Color.fromRGBO(142, 142, 147, 1),
          fontWeight: FontWeight.w400,
        ),  
        contentPadding: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 12,
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: cinzaClaro,
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        color: Colors.black,
      ),
      scaffoldBackgroundColor: Colors.black,
      primaryColor: primaryColor,
      splashColor: Colors.transparent,
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Color.fromRGBO(142, 142, 147, 1),
          fontWeight: FontWeight.w400,
        ),  
        contentPadding: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 12,
        ),
      ),
      fontFamily: 'IBM',
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
    );
  }

  static CalendarDatePicker2WithActionButtonsConfig get calendarTheme {
    return CalendarDatePicker2WithActionButtonsConfig(
      
      calendarType: CalendarDatePicker2Type.single,
      selectedDayHighlightColor: primaryColor,
      closeDialogOnCancelTapped: true,
      closeDialogOnOkTapped: true,

      controlsTextStyle: const TextStyle(
        color: tituloPreto,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),

      weekdayLabelTextStyle: const TextStyle(
        color: cinzaUmPoucoMenosEscuro,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      dayTextStyle: const TextStyle(
        color: tituloPreto,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      selectedDayTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      todayTextStyle: const TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.bold,
      ),
      cancelButtonTextStyle: const TextStyle(
        color: cinzaUmPoucoMenosEscuro,
        fontWeight: FontWeight.w400,
      ),
      okButtonTextStyle: const TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.w500,
      ),
      centerAlignModePicker: true,
    );
  }


  /// Utilizar em icones 
  static const Color cinzaEscuro = Color.fromARGB(255, 93, 90, 90);
  
  static const Color cinzaUmPoucoMenosEscuro = Color.fromARGB(255, 117, 113, 113);

  static const Color cinzaClaro = Color.fromARGB(255, 197, 194, 194);

  static const Color branco = Color.fromARGB(255, 255, 255, 255);

  /// Utilizar em titulos
  static const Color tituloPreto = Color.fromARGB(255, 34, 33, 33);
  
  static const Color primaryColor = Color.fromARGB(255, 0, 123, 255);
}
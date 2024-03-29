import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeData: ThemeData.light())) {
    on<ThemeChanged>((event, emit) {
      emit(
        ThemeState(
          themeData: event.isDarkMode
              ? ThemeData.dark().copyWith(
                  floatingActionButtonTheme: FloatingActionButtonThemeData(
                    backgroundColor: Colors.greenAccent,
                  ),
                )
              : ThemeData.light().copyWith(
                  floatingActionButtonTheme: FloatingActionButtonThemeData(
                    backgroundColor: Colors.greenAccent,
                  ),
                  bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    selectedItemColor: Colors.greenAccent,
                  ),
                ),
        ),
      );
    });
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import 'common/constants.dart';
import 'medication_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'Pill Reminder',
        theme: ThemeData.dark().copyWith(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: kScaffoldColor,
          appBarTheme: AppBarTheme(
            toolbarHeight: 7.h,
            backgroundColor: kScaffoldColor,
            elevation: 0,
            iconTheme: IconThemeData(
              color: kSecondaryColor,
              size: 20.sp,
            ),
            titleTextStyle: GoogleFonts.mulish(
              color: kTextColor,
              fontWeight: FontWeight.w800,
              fontSize: 16.sp,
            ),
          ),
          textTheme: TextTheme(
            headline3: TextStyle(
              fontSize: 28.sp,
              color: kSecondaryColor,
              fontWeight: FontWeight.w500,
            ),
            headline4: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color: kTextColor,
            ),
            headline5: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              color: kTextColor,
            ),
            headline6: GoogleFonts.poppins(
              fontSize: 13.sp,
              color: kTextColor,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
            subtitle1: GoogleFonts.poppins(fontSize: 15.sp, color: kPrimaryColor),
            subtitle2: GoogleFonts.poppins(fontSize: 12.sp, color: kTextLightColor),
            caption: GoogleFonts.poppins(
              fontSize: 9.sp,
              fontWeight: FontWeight.w400,
              color: kTextLightColor,
            ),
            labelMedium: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: kTextColor,
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: kTextLightColor,
                width: 0.7,
              ),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: kTextLightColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor),
            ),
          ),
          timePickerTheme: TimePickerThemeData(
            backgroundColor: kScaffoldColor,
            hourMinuteColor: kTextColor,
            hourMinuteTextColor: kScaffoldColor,
            dayPeriodColor: kTextColor,
            dayPeriodTextColor: kScaffoldColor,
            dialBackgroundColor: kTextColor,
            dialHandColor: kPrimaryColor,
            dialTextColor: kScaffoldColor,
            entryModeIconColor: kOtherColor,
            dayPeriodTextStyle: GoogleFonts.aBeeZee(
              fontSize: 8.sp,
            ),
          ),
        ),
        home: const MedicationHomePage(),
      );
    });
  }
}

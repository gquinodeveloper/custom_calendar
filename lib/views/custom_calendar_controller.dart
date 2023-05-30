import 'dart:math';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CustomCalendarController extends GetxController {
  late AppointmentDataSource dataSource;

  final allowedViews = [
    CalendarView.day,
    CalendarView.week,
    CalendarView.month,
  ];

  late List<Color> colorCollection;

  @override
  void onInit() {
    // TODO: implement onInit
    colorCollection = [];
    random = Random();

    dataSource = AppointmentDataSource(_getDataSourceAppointments());

    super.onInit();
  }

  late Random random;

  List<Appointment> _getDataSourceAppointments() {
    return [
      Appointment(
        startTime: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          9,
        ),
        endTime: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          11,
        ),
        subject: 'Scrum meeting',
      ),
    ];
  }
}

/// An object to set the appointment collection data source to collection, and
/// allows to add, remove or reset the appointment collection.
class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(this.source);

  List<Appointment> source;

  @override
  List<dynamic> get appointments => source;
}

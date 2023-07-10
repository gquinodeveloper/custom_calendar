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
    dataSource = AppointmentDataSource([]);
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
          9, //Hora inicio
        ),
        endTime: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          11, //Hora fin
        ),
        subject: 'Scrum meeting',
      ),
    ];
  }

  saveSchedule() {
    try {
      dataSource = AppointmentDataSource(_getDataSourceAppointments());
      update();
    } catch (error) {
      print(error);
    }
  }
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(this.source);

  List<Appointment> source;

  @override
  List<dynamic> get appointments => source;
}

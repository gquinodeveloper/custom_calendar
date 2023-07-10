import 'package:custom_calendar/models/meeting_model.dart';
import 'package:custom_calendar/models/model.dart';

import 'package:custom_calendar/views/custom_calendar_controller.dart';
import 'package:custom_calendar/views/widgets/appointment_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CustomCalendarView extends StatefulWidget {
  const CustomCalendarView({Key? key}) : super(key: key);

  @override
  State<CustomCalendarView> createState() => _CustomCalendarViewState();
  //CustomCalendarViewState createState() => CustomCalendarViewState();
}

class _CustomCalendarViewState extends State<CustomCalendarView> {
  final CalendarController calendarController = CalendarController();

  Appointment? _selectedAppointment;
  bool _isAllDay = false;
  String _subject = '';
  int _selectedColorIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomCalendarController>(
      init: CustomCalendarController(),
      builder: (controller) => Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextButton(
              onPressed: controller.saveSchedule,
              child: const Text("Nueva visita"),
            ),
           
            Expanded(
              child: SfCalendar(
                backgroundColor: Colors.white,
                showDatePickerButton: true,
                showNavigationArrow: true,
                viewNavigationMode: ViewNavigationMode.none,
                allowAppointmentResize: true,
                allowViewNavigation: true,
      
                view: CalendarView.week,
                //monthViewSettings: MonthViewSettings(showAgenda: true),
                allowedViews: controller.allowedViews,
                //MeetingDataSource(_getDataSource()),
                dataSource: controller.dataSource,
                onTap: (calendarDetails) {
                  _onCalendarTapped(calendarDetails, controller);
                },
                monthViewSettings: const MonthViewSettings(
                  appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                  monthCellStyle: MonthCellStyle(
                      //leadingDatesBackgroundColor: Colors.red,
                      //todayBackgroundColor: Colors.red,
                      ),
                ),
      
                timeSlotViewSettings: const TimeSlotViewSettings(
                  startHour: 0,
                  endHour: 24,
                  nonWorkingDays: <int>[DateTime.saturday, DateTime.sunday],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<MeetingModel> _getDataSource() {
    List<MeetingModel> meetings = <MeetingModel>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(
      today.year,
      today.month,
      today.day,
      9,
      0,
      0,
    );
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings = [
      MeetingModel(
        'Conference',
        startTime,
        endTime,
        const Color(0xFF0F8644),
        false,
      ),
      MeetingModel(
        'Conference',
        startTime,
        endTime,
        Color.fromARGB(255, 52, 43, 182),
        false,
      )
    ];

    return meetings;
  }

//MODAL
  void _onCalendarTapped(CalendarTapDetails calendarTapDetails,
      CustomCalendarController customController) {
    /// Condition added to open the editor, when the calendar elements tapped
    /// other than the header.
    if (calendarTapDetails.targetElement == CalendarElement.header ||
        calendarTapDetails.targetElement == CalendarElement.viewHeader) {
      return;
    }

    _selectedAppointment = null;

    /// Navigates the calendar to day view,
    /// when we tap on month cells in mobile.
    ///
    /// //!model.isWebFullView && calendarController.view == CalendarView.month
    if (calendarController.view == CalendarView.month) {
      calendarController.view = CalendarView.day;
    } else {
      if (calendarTapDetails.appointments != null &&
          calendarTapDetails.targetElement == CalendarElement.appointment) {
        final dynamic appointment = calendarTapDetails.appointments![0];
        if (appointment is Appointment) {
          _selectedAppointment = appointment;
        }
      }

      final DateTime selectedDate = calendarTapDetails.date!;
      final CalendarElement targetElement = calendarTapDetails.targetElement;

      /// To open the appointment editor for web,
      /// when the screen width is greater than 767.
      ///

      //model.isWebFullView && !model.isMobileResolution

      if (true) {
        final bool isAppointmentTapped =
            calendarTapDetails.targetElement == CalendarElement.appointment;
        showDialog<Widget>(
            context: context,
            builder: (BuildContext context) {
              final List<Appointment> appointment = <Appointment>[];
              Appointment? newAppointment;

              /// Creates a new appointment, which is displayed on the tapped
              /// calendar element, when the editor is opened.
/*               if (_selectedAppointment == null) {
                _isAllDay = calendarTapDetails.targetElement ==
                    CalendarElement.allDayPanel;
                _selectedColorIndex = 0;
                _subject = '';
                final DateTime date = calendarTapDetails.date!;

                newAppointment = Appointment(
                  startTime: date,
                  endTime: date.add(const Duration(hours: 1)),
                  //color: _colorCollection[_selectedColorIndex],
                  isAllDay: _isAllDay,
                  subject: _subject == '' ? '(No title)' : _subject,
                );
                appointment.add(newAppointment);

                customController.dataSource.appointments.add(appointment[0]);

                SchedulerBinding.instance
                    .addPostFrameCallback((Duration duration) {
                  customController.dataSource.notifyListeners(
                      CalendarDataSourceAction.add, appointment);
                });

                _selectedAppointment = newAppointment;
              } */

              return WillPopScope(
                onWillPop: () async {
                  if (newAppointment != null) {
                    /// To remove the created appointment when the pop-up closed
                    /// without saving the appointment.
                    customController.dataSource.appointments.removeAt(
                      customController.dataSource.appointments
                          .indexOf(newAppointment),
                    );
                    customController.dataSource.notifyListeners(
                      CalendarDataSourceAction.remove,
                      <Appointment>[newAppointment],
                    );
                  }
                  return true;
                },
                child: Center(
                    child: SizedBox(
                        width: isAppointmentTapped ? 400 : 500,
                        height: isAppointmentTapped
                            ? (_selectedAppointment!.location == null ||
                                    _selectedAppointment!.location!.isEmpty
                                ? 150
                                : 200)
                            : 400,
                        child: Theme(
                            data: ThemeData(),
                            child: Card(
                              margin: EdgeInsets.zero,
                              //color: model.cardThemeColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              child: isAppointmentTapped
                                  ? displayAppointmentDetails(
                                      context,
                                      targetElement,
                                      selectedDate,
                                      _selectedAppointment!,
                                      [],
                                      [],
                                      customController.dataSource,
                                      [],
                                      [],
                                    )
                                  : const SizedBox(),
                              /* ? displayAppointmentDetails(
                                      context,
                                      targetElement,
                                      selectedDate,
                                      _selectedAppointment!,
                                      [],
                                      [],
                                      customController.dataSource,
                                      [],
                                      [],
                                    )
                                  : PopUpAppointmentEditor(
                                      newAppointment,
                                      appointment,
                                      customController.dataSource,
                                      [],
                                      [],
                                      _selectedAppointment ?? Appointment(),
                                      [],
                                      [],
                                    ), */
                            )))),
              );
            });
      } else {
        /// Navigates to the appointment editor page on mobile
        /*  Navigator.push<Widget>(
          context,
          MaterialPageRoute<Widget>(
              builder: (BuildContext context) => AppointmentEditor(
                  model,
                  _selectedAppointment,
                  targetElement,
                  selectedDate,
                  _colorCollection,
                  _colorNames,
                  _dataSource,
                  _timeZoneCollection)),
        ); */
      }
    }
  }

  /// Displays the tapped appointment details in a pop-up view.
  Widget displayAppointmentDetails(
      BuildContext context,
      CalendarElement targetElement,
      DateTime selectedDate,
      //SampleModel model,
      Appointment selectedAppointment,
      List<Color> colorCollection,
      List<String> colorNames,
      CalendarDataSource events,
      List<String> timeZoneCollection,
      List<DateTime> visibleDates) {
    /*  final Color defaultColor = model.themeData != null &&
            model.themeData.colorScheme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black54;

    final Color defaultTextColor = model.themeData != null &&
            model.themeData.colorScheme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black87; */

    final List<Appointment> appointmentCollection = <Appointment>[];

    return ListView(padding: EdgeInsets.zero, children: <Widget>[
      ListTile(
          trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          IconButton(
            splashRadius: 20,
            icon: Icon(
              Icons.edit,
            ),
            onPressed: () {
              Navigator.pop(context);
              showDialog<Widget>(
                  context: context,
                  builder: (BuildContext context) {
                    return WillPopScope(
                        onWillPop: () async {
                          return true;
                        },
                        child: Theme(
                          data: ThemeData(),
                          child: Text("Edit"),
                          /* child: selectedAppointment.appointmentType ==
                                  AppointmentType.normal
                              ? AppointmentEditorWeb(
                                  model,
                                  selectedAppointment,
                                  colorCollection,
                                  colorNames,
                                  events,
                                  timeZoneCollection,
                                  appointmentCollection,
                                  visibleDates,
                                )
                              : _editRecurrence(
                                  context,
                                  model,
                                  selectedAppointment,
                                  colorCollection,
                                  colorNames,
                                  events,
                                  timeZoneCollection,
                                  visibleDates), */
                        ));
                  });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
            ),
            splashRadius: 20,
            onPressed: () {
              if (selectedAppointment.appointmentType ==
                  AppointmentType.normal) {
                Navigator.pop(context);
                events.appointments!.removeAt(
                    events.appointments!.indexOf(selectedAppointment));
                events.notifyListeners(CalendarDataSourceAction.remove,
                    <Appointment>[selectedAppointment]);
              } else {
                Navigator.pop(context);
                showDialog<Widget>(
                    context: context,
                    builder: (BuildContext context) {
                      return WillPopScope(
                          onWillPop: () async {
                            return true;
                          },
                          child: Theme(
                            data: ThemeData(),
                            child: deleteRecurrence(
                              context,
                              selectedAppointment,
                              events,
                            ),
                          ));
                    });
              }
            },
          ),
          IconButton(
            splashRadius: 20,
            icon: Icon(
              Icons.close,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      )),
      ListTile(
          leading: Icon(
            Icons.lens,
            color: selectedAppointment.color,
            size: 20,
          ),
          title: Text(
              selectedAppointment.subject.isNotEmpty
                  ? selectedAppointment.subject
                  : '(No Text)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5),
            /* child: Text(
            _getAppointmentTimeText(selectedAppointment),
            style: TextStyle(
                fontSize: 15,
                color: defaultTextColor,
                fontWeight: FontWeight.w400),
          ), */
          )),
      if (selectedAppointment.resourceIds == null ||
          selectedAppointment.resourceIds!.isEmpty)
        Container()
      else
        ListTile(
          leading: Icon(
            Icons.people,
            size: 20,
          ),
          /* title: Text(
            _getSelectedResourceText(
                selectedAppointment.resourceIds!, events.resources!),
            style: TextStyle(
                fontSize: 15,
                color: defaultTextColor,
                fontWeight: FontWeight.w400)), */
        ),
      if (selectedAppointment.location == null ||
          selectedAppointment.location!.isEmpty)
        Container()
      else
        ListTile(
          leading: Icon(
            Icons.location_on,
            size: 20,
          ),
          title: Text(selectedAppointment.location ?? '',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
        )
    ]);
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<MeetingModel> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

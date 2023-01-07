import 'package:app/providers/userProvider.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UploadDatesBoxWidget extends StatefulWidget {
  Function(List) onDatesSelected;
  List dates;
  UploadDatesBoxWidget(
      {super.key, required this.onDatesSelected, required this.dates});

  @override
  State<UploadDatesBoxWidget> createState() => _UploadDatesBoxWidgetState();
}

class _UploadDatesBoxWidgetState extends State<UploadDatesBoxWidget> {
  List dates = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

      setState(() {
        dates = widget.dates;
      });
    
  }

  @override
  Widget build(BuildContext context) {
    print(dates);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return Column(
      children: [
        DateTimeFormField(
          firstDate: DateTime.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch),
          lastDate: DateTime.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch +
                  (DateTime.utc(DateTime.now().year + 3)
                          .toUtc()
                          .millisecondsSinceEpoch -
                      DateTime.now().millisecondsSinceEpoch)),
          use24hFormat: true,
          // initialDate: DateTime.fromMillisecondsSinceEpoch(userProvider.currentUser!.dateOfBirth ?? DateTime.now().millisecondsSinceEpoch),
          initialValue: DateTime.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch),
          decoration: const InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black45,
                width: 1,
              ),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black45,
                width: 1,
              ),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            contentPadding: EdgeInsets.all(20),
            suffixIcon: Icon(Icons.add),
            labelText: "Avilable Dates",
          ),
          mode: DateTimeFieldPickerMode.dateAndTime,
          // autovalidateMode: AutovalidateMode.always,
          onDateSelected: (value) {
            if (value.year > DateTime.now().year + 3 ||
                value.millisecondsSinceEpoch <
                    DateTime.now().millisecondsSinceEpoch ||
                dates.contains(value) ||
                dates.length > 3) {
              return;
            }

            print("Date");
            print(value.millisecondsSinceEpoch);
            setState(() {
              dates.add(value.millisecondsSinceEpoch);
            });
            widget.onDatesSelected(dates);
          },
        ),
        ...dates.map((e) {
          return Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MM/dd/yyyy, hh:mm a')
                      .format(DateTime.fromMillisecondsSinceEpoch(e)),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        dates.remove(e);
                      });
                      widget.onDatesSelected(dates);
                    },
                    icon: const Icon(Icons.delete)),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}

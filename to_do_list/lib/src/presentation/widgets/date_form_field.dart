import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/src/config/themes/app_theme.dart';

class DateFormField extends StatelessWidget {
  final void Function(DateTime date) onDateSelected;

  DateFormField({super.key, required this.onDateSelected});

  final ValueNotifier<DateTime?> _selectedDate = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await showCalendarDatePicker2Dialog(
          context: context,
          config: AppTheme.calendarTheme,
          dialogSize: const Size(325, 400),
          value: [
            DateTime.now()
          ],
        );

        if (result != null && result.isNotEmpty) {
          _selectedDate.value = result.first;
          onDateSelected(_selectedDate.value!);
        }
      },
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8)
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                ValueListenableBuilder(
                  valueListenable: _selectedDate,
                  builder: (context, value, child) => Text(
                    _selectedDate.value != null ? '${_selectedDate.value!.day}/${_selectedDate.value!.month}/${_selectedDate.value!.year}' : '00/00/0000',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.date_range_outlined,
                  size: 16,
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}
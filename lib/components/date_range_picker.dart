import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangePicker extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(DateTime startDate, DateTime endDate) onDateRangeSelected;

  const DateRangePicker({
    this.initialStartDate,
    this.initialEndDate,
    required this.onDateRangeSelected,
    super.key,
  });

  @override
  DateRangePickerState createState() => DateRangePickerState();
}

class DateRangePickerState extends State<DateRangePicker> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    // Initialize the start and end dates with the provided values
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Select Date Range', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => _selectDate(context, true),
                  child: Text(_startDate != null ? DateFormat('yyyy-MM-dd').format(_startDate!) : 'Select Start Date'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextButton(
                  onPressed: () => _selectDate(context, false),
                  child: Text(_endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : 'Select End Date'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  final now = DateTime.now();
                  setState(() {
                    _startDate = DateTime(now.year, now.month, 1);
                    _endDate = DateTime(now.year, now.month + 1, 0);
                  });
                  widget.onDateRangeSelected(_startDate!, _endDate!); // Notify parent about the reset
                  Navigator.pop(context);
                },
                child: const Text('Clear'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_startDate != null && _endDate != null) {
                    widget.onDateRangeSelected(_startDate!, _endDate!);
                    Navigator.pop(context);
                  } else {
                    // Optionally show a message to select dates
                  }
                },
                child: const Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

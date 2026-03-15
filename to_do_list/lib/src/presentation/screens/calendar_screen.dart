import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // Lista que armazena a data selecionada

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime(2023, 10, 5);
  DateTime? _selectedDay = DateTime(2023, 10, 5);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.chevron_left, color: Colors.blue),
        title: const Text(
          'October 2023', // Poderia ser dinâmico baseado na seleção
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.blue),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildViewSelector(), // Seletor Month/Week
          const SizedBox(height: 10),
          _buildCalendar(),      // O calendário propriamente dito
          const Divider(),       // Linha de separação
        ],
      ),
    );
  }

  Widget _buildViewSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _viewOption("Month", CalendarFormat.month),
          _viewOption("Week", CalendarFormat.week),
        ],
      ),
    );
  }

  Widget _viewOption(String title, CalendarFormat format) {
    bool isSelected = _calendarFormat == format;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _calendarFormat = format),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))] : [],
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.black : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  // 2. Configuração do CalendarDatePicker2
  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2023, 1, 1),
      lastDay: DateTime.utc(2024, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      headerVisible: false, // Usamos nosso próprio AppBar
      availableGestures: AvailableGestures.all,
      
      // Lógica de Seleção
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },

      // Lógica de Eventos (Bolinhas)
      eventLoader: _getTasksForDay,

      // Estilização dos Dias da Semana (S M T W T F S)
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Colors.grey[400]!, fontSize: 11, fontWeight: FontWeight.w700),
        weekendStyle: TextStyle(color: Colors.grey[400]!, fontSize: 11, fontWeight: FontWeight.w700),
        dowTextFormatter: (date, locale) => DateFormat.E(locale).format(date)[0].toUpperCase(),
      ),

      // Estilização do Calendário
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        defaultTextStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
        weekendTextStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
        outsideTextStyle: TextStyle(fontSize: 17, color: Colors.grey[300]),
        
        // Círculo Azul do dia selecionado
        selectedDecoration: const BoxDecoration(
          color: Color(0xFF007AFF),
          shape: BoxShape.circle,
        ),
        
        // Dia de hoje (removendo destaque para focar na seleção manual)
        todayDecoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF007AFF).withOpacity(0.5)),
          shape: BoxShape.circle,
        ),
        todayTextStyle: const TextStyle(color: Color(0xFF007AFF), fontSize: 17),

        // Configuração das Bolinhas (Markers)
        markerSize: 4,
        markerMargin: const EdgeInsets.only(top: 6),
        markersAlignment: Alignment.bottomCenter,
        markerDecoration: const BoxDecoration(
          color: Color(0xFF007AFF), // Cor da bolinha
          shape: BoxShape.circle,
        ),
      ),
      
      // Customização avançada para as bolinhas
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isNotEmpty) {
            // Se o dia estiver selecionado, não mostramos a bolinha (conforme a imagem)
            if (isSameDay(date, _selectedDay)) return const SizedBox();
            
            return Container(
              margin: const EdgeInsets.only(top: 30),
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                // Dias 1 e 7 na imagem têm bolinhas cinzas, os outros azuis claros
                color: (date.day == 1 || date.day == 7) 
                    ? Colors.grey[300] 
                    : const Color(0xFF007AFF).withOpacity(0.4),
                shape: BoxShape.circle,
              ),
            );
          }
          return null;
        },
      ),
    );
  }

  List<Widget> _getTasksForDay(DateTime day) {
    return  [];
  }

}
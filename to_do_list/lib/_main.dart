import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class TaskCalendarApp extends StatelessWidget {
  const TaskCalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: '.SF Pro Text', // Estilo iOS
        primaryColor: const Color(0xFF007AFF),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const CalendarScreen(),
    );
  }
}

// Modelo de Tarefa
class Task {
  final String title;
  final String time;
  final Color color;
  bool isDone;

  Task({
    required this.title,
    required this.time,
    required this.color,
    this.isDone = false,
  });
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime(2023, 10, 5);
  DateTime? _selectedDay = DateTime(2023, 10, 5);

  // MAPA DE TAREFAS: As bolinhas só aparecerão nos dias contidos aqui
  final Map<DateTime, List<Task>> _tasksByDay = {
    DateTime(2023, 10, 1): [Task(title: "Task 1", time: "09:00", color: Colors.grey)],
    DateTime(2023, 10, 3): [Task(title: "Task 2", time: "10:00", color: Colors.blue)],
    DateTime(2023, 10, 5): [
      Task(title: "Review Design Specs", time: "10:00 AM", color: Colors.green),
      Task(title: "Sync with Frontend Team", time: "01:30 PM", color: Colors.amber),
      Task(title: "Buy birthday gift", time: "04:00 PM", color: const Color(0xFF007AFF), isDone: true),
      Task(title: "Productivity App Launch", time: "06:00 PM", color: Colors.red),
    ],
    DateTime(2023, 10, 7): [Task(title: "Task 3", time: "11:00", color: Colors.grey)],
    DateTime(2023, 10, 9): [Task(title: "Task 4", time: "12:00", color: Colors.blue)],
    DateTime(2023, 10, 12): [Task(title: "Task 5", time: "14:00", color: Colors.blue)],
    DateTime(2023, 10, 16): [Task(title: "Task 6", time: "16:00", color: Colors.blue)],
  };

  List<Task> _getTasksForDay(DateTime day) {
    // Normaliza a data para evitar problemas com horas/minutos
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _tasksByDay[normalizedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildViewSelector(),
          _buildTableCalendar(),
          const SizedBox(height: 10),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF2F2F7)),
          Expanded(child: _buildTaskList()),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: const Icon(Icons.chevron_left, color: Color(0xFF007AFF), size: 30),
      title: Text(
        DateFormat('MMMM yyyy').format(_focusedDay),
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 17),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Color(0xFF007AFF), size: 26),
          onPressed: () {},
        ),
      ],
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

  Widget _buildTableCalendar() {
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

  Widget _buildTaskList() {
    final dayTasks = _getTasksForDay(_selectedDay!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('EEEE, MMM d').format(_selectedDay!),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.5),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: const Color(0xFF007AFF).withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.add, color: Color(0xFF007AFF), size: 20),
              )
            ],
          ),
        ),
        Expanded(
          child: dayTasks.isEmpty 
            ? const Center(child: Text("No tasks for this day", style: TextStyle(color: Colors.grey)))
            : ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: dayTasks.length,
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(left: 70),
                  child: Divider(height: 1, thickness: 0.5, color: Colors.grey[200]),
                ),
                itemBuilder: (context, index) {
                  final task = dayTasks[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => task.isDone = !task.isDone),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: task.isDone ? const Color(0xFF007AFF) : Colors.transparent,
                              border: Border.all(color: task.isDone ? const Color(0xFF007AFF) : Colors.grey[300]!, width: 1.5),
                              shape: BoxShape.circle,
                            ),
                            child: task.isDone ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: task.isDone ? Colors.grey[400] : Colors.black,
                                  decoration: task.isDone ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(task.time, style: TextStyle(color: Colors.grey[400], fontSize: 13, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        if (!task.isDone)
                          Container(width: 7, height: 7, decoration: BoxDecoration(color: task.color, shape: BoxShape.circle)),
                      ],
                    ),
                  );
                },
              ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        border: Border(top: BorderSide(color: Colors.grey[100]!, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.calendar_today_outlined, "Today", false),
          _navItem(Icons.calendar_month, "Calendar", true),
          _navItem(Icons.list_alt_rounded, "Lists", false),
          _navItem(Icons.settings_outlined, "Settings", false),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool active) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: active ? const Color(0xFF007AFF) : Colors.grey[300], size: 26),
        const SizedBox(height: 5),
        Text(label, style: TextStyle(color: active ? const Color(0xFF007AFF) : Colors.grey[300], fontSize: 10, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
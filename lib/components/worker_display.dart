import 'package:flutter/material.dart';

class WorkerDisplay extends StatefulWidget {
  final Map<String, List<String>> workers;

  const WorkerDisplay({Key? key, required this.workers}) : super(key: key);

  @override
  State<WorkerDisplay> createState() => _WorkerDisplayState();
}

class _WorkerDisplayState extends State<WorkerDisplay> {

  late Map<String, List<String>> _workers;

  _updateSelfState(Map<String, List<String>> workers) {
    _workers = workers;
  }

  @override
  void initState() {
    super.initState();
    _updateSelfState(widget.workers);
  }
  @override
  void didUpdateWidget(WorkerDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateSelfState(widget.workers);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _workers.entries.map((department) => 
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                department.key,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            ...department.value.asMap().entries.map((entry) => 
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  entry.value,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ).toList()
          ]
        )
      ).toList()
    );
  }
}

import 'package:flutter/material.dart';

class ConstrainedSidebar extends StatelessWidget {

  final Widget child;

  const ConstrainedSidebar({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
  ConstrainedBox(
    constraints: const BoxConstraints(
      minWidth: 400,
    ),
    child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.25,
      child: child
    ),
  );
}
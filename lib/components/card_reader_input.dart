import 'package:flutter/material.dart';

class CardReaderInput extends StatefulWidget {
  final void Function(String value) onSubmitted;
  const CardReaderInput({Key? key, required this.onSubmitted}) : super(key: key);

  @override
  State<CardReaderInput> createState() => _CardReaderInputState();
}

class _CardReaderInputState extends State<CardReaderInput> {

  final FocusNode _cardFieldFocusNode = FocusNode(skipTraversal: true, canRequestFocus: true, descendantsAreFocusable: true);
  final TextEditingController _cardFieldController = TextEditingController();
  late void Function(String value) _onSubmitted;

  @override
  void initState() {
    super.initState();
    _onSubmitted = widget.onSubmitted;
    _cardFieldFocusNode.addListener(() {
    if (!_cardFieldFocusNode.hasFocus) {
      _cardFieldFocusNode.requestFocus();
    }
    });
  }

  @override
  void dispose() {
    _cardFieldFocusNode.dispose();
    _cardFieldController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext build) {
    return SizedBox(
      width: 0,
      child: TextField(
        autofocus: true,
        onSubmitted: (String value) {
          _onSubmitted(value);
          _cardFieldController.clear();
          _cardFieldFocusNode.requestFocus();
        },
        focusNode: _cardFieldFocusNode,
        controller: _cardFieldController,
      ),
    );
  }
}
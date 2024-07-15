import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {

  TextEditingController controller;
  String textHint;
  void Function(String)? onChanged;
  MyTextField({super.key, required this.controller, required this.textHint, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextField(
        cursorColor: Colors.white,
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 20),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            // enabledBorder: OutlineInputBorder(
            //     borderSide:
            //         BorderSide(color: Colors.black)),
           
            // focusedBorder: const OutlineInputBorder(
            //     borderSide:
            //         BorderSide(color: Colors.black)),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(8))),
            fillColor: Colors.grey.shade700,
            filled: true,
            contentPadding: const EdgeInsets.all(8),
            hintText: textHint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 20,)),
            onChanged: onChanged,
      ),
    );
  }
}
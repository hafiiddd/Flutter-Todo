import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:msh_checkbox/msh_checkbox.dart';

class toDo extends StatefulWidget {
  const toDo(
      {super.key,
      required this.nama,
      required this.detail,
      required this.handleDelete,
      required this.id});
  final String id;
  final String nama;
  final String detail;
  final void Function(String) handleDelete;

  @override
  State<toDo> createState() => _toDoState();
}

class _toDoState extends State<toDo> {
  bool? check = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        !check!
            ? showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(widget.nama),
                    content: Text(widget.detail),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Close"),
                      ),
                    ],
                  );
                },
              )
            : print("sudah hilang");
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        height: 110,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: [
              Text(
                widget.nama,
                style: check!
                    ? TextStyle(
                        decoration: TextDecoration.lineThrough,
                        fontSize: 20,
                        color: const Color.fromARGB(255, 133, 131, 131),
                      )
                    : TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
              ),
              Spacer(),
              MSHCheckbox(
                size: 25,
                value: check!,
                duration: Duration(milliseconds: 300),
                colorConfig: MSHColorConfig.fromCheckedUncheckedDisabled(
                  checkedColor: const Color.fromARGB(255, 8, 224, 124),
                ),
                style: MSHCheckboxStyle.stroke,
                onChanged: (selected) async {
                  setState(() {
                    check = selected;
                  });

                  if (check!) {
                    await Future.delayed(Duration(milliseconds: 600));
                    widget.handleDelete(widget.id);
                    setState(() {
                      check = false;
                    });
                  }
                },
              ),
              Divider()
            ],
          ),
        ),
      ),
    );
  }
}

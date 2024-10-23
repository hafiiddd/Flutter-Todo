import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:get/get.dart';
import 'package:to_do_list/app/modules/widgets/toDo.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  final _textEditingControllerNama = TextEditingController();
  final _textEditingControllerDetail = TextEditingController();
  void handleSubmitTodo() {
    final newData = {
      'nama': _textEditingControllerNama.text,
      'detail': _textEditingControllerDetail.text,
      'check': false,
      'time' : FieldValue.serverTimestamp()
    };

    FirebaseFirestore.instance.collection('todo').doc().set(newData);
  }

  void handleDeleteTodo(String id) async{
    await FirebaseFirestore.instance.collection('todo').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    Future openDiaglog() {
      _textEditingControllerNama.clear();
      _textEditingControllerDetail.clear();
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("To Do"),
          content: Container(
            height: 100,
            child: Column(
              children: [
                TextField(
                  controller: _textEditingControllerNama,
                  decoration: InputDecoration(hintText: "nama"),
                ),
                TextField(
                  controller: _textEditingControllerDetail,
                  decoration: InputDecoration(hintText: "detail"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  handleSubmitTodo();
                  Navigator.of(context).pop();
                },
                child: Text("confirm"))
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          'To Do List',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
  
            StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('todo').orderBy('time').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("mohon tunggu...");
                  }
                  if (snapshot.hasData == false) {
                    return Text("no data");
                  }
                  print(snapshot.data!.docs);

                  return Column(
                    children: [
                      for (var data in snapshot.data!.docs)
                        toDo(
                          id: data.id,
                          nama: data.data()['nama'],
                          detail: data.data()['detail'],
                          handleDelete: handleDeleteTodo,
                          
                        ),
                    ],
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openDiaglog();
        },
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple,
      ),
    );
  }
}

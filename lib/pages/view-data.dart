import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:todo_app_firebase/pages/home-page.dart';

class ViewData extends StatefulWidget {
  final Map<String, dynamic> document;
  final String id;

  const ViewData({super.key, required this.document, required this.id});

  @override
  State<ViewData> createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _titleController;
  TextEditingController? _descriptionController;
  String? type;
  String? category;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.document["title"]);
    _descriptionController =
        TextEditingController(text: widget.document["description"]);
    type = widget.document["task"];
    category = widget.document["category"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff070F2B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Get.to(() => HomePage(),
                transition: Transition.leftToRight,
                duration: Duration(milliseconds: 600));
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                QuickAlert.show(
                    context: context,
                    type: QuickAlertType.warning,
                    text: 'Are you sure want to delete?',
                    showConfirmBtn: true,
                    showCancelBtn: true,
                    confirmBtnText: "Yes",
                    cancelBtnText: "Cancel",
                    confirmBtnColor: Color.fromARGB(255, 75, 150, 131),
                    onConfirmBtnTap: () {
                      FirebaseFirestore.instance
                          .collection("Todo")
                          .doc(widget.id)
                          .delete()
                          .then(
                            (value) => QuickAlert.show(
                              context: context,
                              type: QuickAlertType.success,
                              text: 'Task succes been deleted',
                              confirmBtnColor:
                                  Color.fromARGB(255, 75, 150, 131),
                            ),
                          );
                      Get.off(() => HomePage());
                    },
                    onCancelBtnTap: () {
                      Get.back();
                    });
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Detail\nYour Todo",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Poppins",
                      fontSize: 26,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Task Title",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins",
                        fontSize: 16)),
                SizedBox(
                  height: 8,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(3),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: _titleController,
                      validator: (value) =>
                          value == "" ? "Please fill your task title" : null,
                      decoration: InputDecoration(
                        hintText: 'Task title',
                        hintStyle: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14,
                            color: Colors.grey),
                        prefixIcon: Icon(
                          Icons.description,
                          color: Colors.grey,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 75, 150, 131)),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        contentPadding: EdgeInsets.only(top: 10),
                        filled: true,
                        fillColor: Color(0xff2a2e3d),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Task Type",
                  style: TextStyle(
                      fontFamily: "Poppins", fontSize: 16, color: Colors.white),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    taskSelected("Important", 0xff2664fa),
                    SizedBox(
                      width: 10,
                    ),
                    taskSelected("Planned", 0xff2bc8d9),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Description",
                  style: TextStyle(
                      fontFamily: "Poppins", color: Colors.white, fontSize: 16),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xff2a2e3d),
                    labelText: "Task description",
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelStyle: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.grey,
                        fontSize: 14),
                    alignLabelWithHint: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 75, 150, 131)),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                  ),
                  maxLines: null,
                  minLines: 5,
                  keyboardType: TextInputType.multiline,
                  validator: (value) =>
                      value == "" ? "Please fill your task description" : null,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Category",
                  style: TextStyle(
                      fontFamily: "Poppins", color: Colors.white, fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                Wrap(
                  children: [
                    categories("Food", 0xffFF407D),
                    SizedBox(
                      width: 10,
                    ),
                    categories("Workout", 0xff2bd9a1),
                    SizedBox(
                      width: 10,
                    ),
                    categories("Work", 0xff836FFF),
                    SizedBox(
                      width: 10,
                    ),
                    categories("Design", 0xff2bc8d9),
                    SizedBox(
                      width: 10,
                    ),
                    categories("Run", 0xffF57D1F),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
        child: InkWell(
          onTap: () async {
            if (_formKey.currentState!.validate() &&
                type!.isNotEmpty &&
                category!.isNotEmpty) {
              FirebaseFirestore.instance
                  .collection("Todo")
                  .doc(widget.id)
                  .update({
                "title": _titleController!.text,
                "task": type,
                "category": category,
                "description": _descriptionController!.text
              });
              await QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                text: 'Task success updated',
                confirmBtnColor: Color.fromARGB(255, 75, 150, 131),
              );
              Get.off(() => HomePage());
            } else {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.warning,
                confirmBtnText: "Yes",
                showConfirmBtn: true,
                onConfirmBtnTap: () => Get.back(),
                confirmBtnColor: Colors.orangeAccent,
                title: "Warning",
                text:
                    "Please select a task type & category before adding a todo.",
              );
            }
          },
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width - 60,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 75, 150, 131),
                borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: Text(
                "Update Todo",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget taskSelected(String label, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          if (type == label) {
            type = "";
          } else {
            type = label;
          }
        });
      },
      child: Chip(
        backgroundColor: Color(color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            width: 2.5,
            color: type == label ? Colors.white54 : Colors.transparent,
          ),
        ),
        label: Text(
          label,
          style: TextStyle(
              fontFamily: "Poppins", fontSize: 14, color: Colors.white),
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      ),
    );
  }

  Widget categories(String label, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          if (category == label) {
            category = "";
          } else {
            category = label;
          }
        });
      },
      child: Chip(
        backgroundColor: Color(color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            width: 2.5,
            color: category == label ? Colors.white54 : Colors.transparent,
          ),
        ),
        label: Text(
          label,
          style: TextStyle(
              fontFamily: "Poppins", fontSize: 14, color: Colors.white),
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_firebase/pages/home-page.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create\nNew Todo",
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
              /* Search box */
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(3),
                  child: TextField(
                    /* controller: searchController, */
                    onSubmitted: (value) {
                      /* _performSearch(); */
                    },
                    decoration: InputDecoration(
                      hintText: 'Task title',
                      hintStyle: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          color: Colors.grey),
                      prefixIcon: IconButton(
                          onPressed: () {
                            /* Get.to(() => SearchAllScreen(
                                              typedKeyWords:
                                                  searchController.text)); */
                          },
                          icon: Icon(
                            Icons.description,
                            color: Colors.grey,
                          )),
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
              /* Search box end */
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
                  chipData("Important", 0xff2664fa),
                  SizedBox(
                    width: 10,
                  ),
                  chipData("Planned", 0xff2bc8d9),
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
                /* controller: streetAddressEditingController, */
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xff2a2e3d),
                  labelText: "Task description",
                  labelStyle: TextStyle(
                      fontFamily: "Poppins", color: Colors.grey, fontSize: 14),
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
                onSaved: (value) {
                  /*  streetAddressEditingController.text = value!; */
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Category",
                style: TextStyle(
                    fontFamily: "Poppins", color: Colors.white, fontSize: 16),
              ),
              Wrap(
                children: [
                  chipData("Food", 0xffFF407D),
                  SizedBox(
                    width: 10,
                  ),
                  chipData("Workout", 0xff2bd9a1),
                  SizedBox(
                    width: 10,
                  ),
                  chipData("Work", 0xff836FFF),
                  SizedBox(
                    width: 10,
                  ),
                  chipData("Design", 0xff2bc8d9),
                  SizedBox(
                    width: 10,
                  ),
                  chipData("Run", 0xffF57D1F),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
        child: InkWell(
          onTap: () {},
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width - 60,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 75, 150, 131),
                borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: Text(
                "Add Todo",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget chipData(String label, int color) {
    return Chip(
      backgroundColor: Color(color),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Colors.transparent,
        ),
      ),
      label: Text(
        label,
        style:
            TextStyle(fontFamily: "Poppins", fontSize: 14, color: Colors.white),
      ),
      labelPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
    );
  }
}

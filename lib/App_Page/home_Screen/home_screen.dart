import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:note_hive/App_Page/home_Screen/controller/home_controller.dart';
import 'package:note_hive/Core/Model/box.dart';
import 'package:note_hive/Core/Model/note_model.dart';
import 'package:note_hive/Core/utils/size_utils.dart';
import 'package:readmore/readmore.dart';

class HomeScreen extends GetWidget<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Notes",
          style: TextStyle(
              fontSize: f(context, 20),
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getdata().listenable(),
        builder: (context, box, _) {
          var data = box.values.toList().cast<NotesModel>();
          return box.isEmpty
              ? const Center(child: Text("No Data Found"))
              : ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: w(context, 15), vertical: h(context, 5)),
                      child: Card(
                        color: Colors.white,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 100),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: w(context, 20),
                                  vertical: h(context, 10)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: h(context, 5)),
                                        Text(
                                          data[index].title.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: f(context, 20)),
                                        ),
                                        SizedBox(height: h(context, 5)),
                                        ReadMoreText(
                                          textAlign: TextAlign.start,
                                          data[index].content.toString(),
                                          trimLines: 2,
                                          colorClickableText: Colors.orange,
                                          trimMode: TrimMode.Line,
                                          trimCollapsedText: 'Show more',
                                          trimExpandedText: 'Show less',
                                          style: TextStyle(
                                              fontSize: f(context, 12),
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                          moreStyle: TextStyle(
                                              fontSize: f(context, 12),
                                              fontWeight: FontWeight.bold,
                                              color: Colors.orange),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: w(context, 10)),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            _showMyDialog(
                                                isAdd: false,
                                                noteModel: data[index],
                                                title: data[index]
                                                    .title
                                                    .toString(),
                                                description: data[index]
                                                    .content
                                                    .toString(),
                                                context: context);
                                          },
                                          child: const Icon(
                                            Icons.edit,
                                            color: Colors.black,
                                            size: 25,
                                          )),
                                      SizedBox(
                                        height: h(context, 10),
                                      ),
                                      InkWell(
                                          onTap: () {
                                            delete(data[index]);
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red.withOpacity(0.8),
                                            size: 25,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          controller.titleController.clear();
          controller.contentController.clear();
          _showMyDialog(isAdd: true, context: context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  void delete(NotesModel noteModel) async {
    await noteModel.delete();
  }

  Future<void> _showMyDialog(
      {bool isAdd = true,
      required BuildContext context,
      NotesModel? noteModel,
      String? title,
      String? description}) async {
    controller.titleController.text = title ?? "";
    controller.contentController.text = description ?? "";
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isAdd ? "Add Notes" : "Edit Notes"),
          content: SingleChildScrollView(
            child: Form(
              key: controller.formkey,
              child: Column(
                children: [
                  SizedBox(
                    width: w(context, 400),
                    child: TextFormField(
                      controller: controller.titleController,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: Colors.teal, width: w(context, 2)),
                          ),
                          hintText: "Enter title",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          )),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Title';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: h(context, 10),
                  ),
                  SizedBox(
                    width: w(context, 400),
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      controller: controller.contentController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Colors.teal, width: w(context, 2)),
                        ),
                        hintText: "Enter Content",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Content';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                )),
            TextButton(
                onPressed: () async {
                  if (controller.formkey.currentState!.validate()) {
                    if (isAdd) {
                      Get.back();
                      final data = NotesModel(
                        title: controller.titleController.text,
                        content: controller.contentController.text,
                      );
                      final box = Boxes.getdata();
                      box.add(data);
                      data.save();
                      controller.titleController.clear();
                      controller.contentController.clear();
                    } else {
                      if (noteModel != null) {
                        noteModel.title =
                            controller.titleController.text.toString();
                        noteModel.content =
                            controller.contentController.text.toString();
                        await noteModel.save();
                        controller.titleController.clear();
                        controller.contentController.clear();
                        Get.back();
                      }
                    }
                  }
                },
                child: Text(
                  isAdd ? "Add" : "Edit",
                  style: const TextStyle(color: Colors.black),
                ))
          ],
        );
      },
    );
  }
}

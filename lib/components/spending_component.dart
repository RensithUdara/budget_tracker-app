import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:budget_tracker_app/controller/spending_controller.dart';

import '../helper/db_helper.dart';
import '../model/category_model.dart';
import '../model/spending_model.dart';

TextEditingController desController = TextEditingController();
TextEditingController amtController = TextEditingController();
GlobalKey<FormState> key = GlobalKey<FormState>();

class SpendingComponent extends StatelessWidget {
  const SpendingComponent({super.key});

  @override
  Widget build(BuildContext context) {
    SpendingController controller = Get.put(SpendingController());
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Spending',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: GetBuilder<SpendingController>(builder: (ctx) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Form(
              key: key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: amtController,
                          validator: (value) =>
                              value!.isEmpty ? "Required..." : null,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Amount',
                            hintText: 'Enter an amount',
                            labelStyle: const TextStyle(color: Colors.teal),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.teal),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: desController,
                          validator: (value) =>
                              value!.isEmpty ? "Required..." : null,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Description',
                            hintText: 'Enter a description',
                            labelStyle: const TextStyle(color: Colors.teal),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.teal),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text(
                              "Modes:",
                              style:
                                  TextStyle(color: Colors.teal, fontSize: 16),
                            ),
                            const SizedBox(width: 8),
                            DropdownButton<String>(
                              dropdownColor: Colors.grey[200],
                              value: controller.spendingMode,
                              style: const TextStyle(color: Colors.black),
                              hint: const Text(
                                "Select Mode",
                                style: TextStyle(color: Colors.black54),
                              ),
                              items: const [
                                DropdownMenuItem<String>(
                                  value: "Cash",
                                  child: Text("Cash"),
                                ),
                                DropdownMenuItem<String>(
                                  value: "Card",
                                  child: Text("Card"),
                                ),
                                DropdownMenuItem<String>(
                                  value: "Digital",
                                  child: Text("Digital"),
                                ),
                              ],
                              onChanged: (value) =>
                                  controller.setSpendingMode(mode: value),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text(
                              "Date: ",
                              style:
                                  TextStyle(color: Colors.teal, fontSize: 16),
                            ),
                            const SizedBox(width: 5),
                            IconButton(
                              onPressed: () async {
                                DateTime? date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2026),
                                  initialDate: DateTime.now(),
                                );
                                if (date != null) {
                                  controller.setSpendingDate(date: date);
                                }
                              },
                              icon: const Icon(
                                Icons.calendar_month,
                                color: Colors.teal,
                              ),
                            ),
                            if (controller.spendingDate != null)
                              Text(
                                controller.spendingDate
                                    .toString()
                                    .substring(0, 10),
                                style: const TextStyle(color: Colors.black87),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 100,
                          child: FutureBuilder(
                            future: DBHelper.dbHelper.fetchCategoryData(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<CategoryModel> allCategoryData =
                                    snapshot.data ?? [];
                                return GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemCount: allCategoryData.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        controller.setSpendingIndex(
                                          index: index,
                                          id: allCategoryData[index].id,
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: controller.spendingIndex ==
                                                    index
                                                ? Colors.teal
                                                : Colors.transparent,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                            image: MemoryImage(
                                                allCategoryData[index].image),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (key.currentState!.validate() &&
                          controller.spendingMode != null &&
                          controller.spendingDate != null &&
                          controller.spendingIndex != null) {
                        controller.addSpendings(
                          model: SpendingModel(
                            id: 0,
                            descripsion: desController.text,
                            amount: num.parse(amtController.text),
                            mode: controller.spendingMode!,
                            date: controller.spendingDate
                                .toString()
                                .substring(0, 10),
                            categoryId: controller.categoryId,
                          ),
                        );
                        amtController.clear();
                        desController.clear();
                        controller.resetValues();
                        Get.snackbar(
                          "Success",
                          "Spending add Completed",
                          backgroundColor: Colors.green.shade300,
                          colorText: Colors.white,
                        );
                      } else {
                        Get.snackbar(
                          "Error",
                          "Please fil all details",
                          backgroundColor: Colors.red.shade300,
                          colorText: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      "Add",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:budget_tracker_app/controller/category_controller.dart';

List<String> categoryImage = [
  "assets/images/category/bill.png",
  "assets/images/category/cash.png",
  "assets/images/category/communication.png",
  "assets/images/category/deposit.png",
  "assets/images/category/food.png",
  "assets/images/category/gift.png",
  "assets/images/category/health.png",
  "assets/images/category/movie.png",
  "assets/images/category/rupee.png",
  "assets/images/category/salary.png",
  "assets/images/category/shopping.png",
  "assets/images/category/transport.png",
  "assets/images/category/wallet.png",
  "assets/images/category/withdraw.png",
  "assets/images/category/other.png",
  "assets/images/category/birthday.png",
  "assets/images/category/car.png",
  "assets/images/category/cinema.png",
  "assets/images/category/concert.png",
  "assets/images/category/christmas.png",
  "assets/images/category/grocery.png",
  "assets/images/category/gym.png",
  "assets/images/category/insurance.png",
  "assets/images/category/parking.png",
  "assets/images/category/pet.png",
  "assets/images/category/recharge.png",
  "assets/images/category/rent.png",
  "assets/images/category/salon.png",
  "assets/images/category/school.png",
  "assets/images/category/vacation.png",
];

GlobalKey<FormState> formKey = GlobalKey<FormState>();
TextEditingController categoryController = TextEditingController();

class CategoryComponent extends StatelessWidget {
  const CategoryComponent({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryController controller = Get.put(CategoryController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Category',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Category Name: ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: categoryController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Category Name ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.teal,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select an Icon:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: categoryImage.length,
                  itemBuilder: (context, index) {
                    return GetBuilder<CategoryController>(
                      builder: (controller) {
                        return GestureDetector(
                          onTap: () {
                            controller.changeIndex(index: index);
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: controller.categoryIndex == index
                                    ? Colors.teal
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(categoryImage[index]),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate() &&
                          controller.categoryIndex != null) {
                        String name = categoryController.text;
                        String imagePath =
                            categoryImage[controller.categoryIndex!];
                        ByteData data = await rootBundle.load(imagePath);
                        Uint8List image = data.buffer.asUint8List();
                        controller.addCategory(name: name, image: image);

                        Get.snackbar('Success', 'Category add Completed',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white);
                      } else {
                        Get.snackbar('Error', 'Please fill all details',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white);
                      }

                      categoryController.clear();
                      controller.updateIndex();
                    },
                    child: const Text(
                      'Add Category',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

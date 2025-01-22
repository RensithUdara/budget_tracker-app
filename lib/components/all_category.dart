import 'package:budget_tracker_app/components/category_component.dart';
import 'package:budget_tracker_app/controller/category_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../model/category_model.dart';

class AllCategory extends StatelessWidget {
  const AllCategory({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryController controller = Get.put(CategoryController());
    controller.fetchCategory();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Category',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon:
                    const Icon(CupertinoIcons.search, color: Colors.teal),
                hintText: 'Search',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                controller.searchCategory(search: value);
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GetBuilder<CategoryController>(
              builder: (context) {
                return FutureBuilder(
                  future: controller.categoryList,
                  builder: (context, snapShot) {
                    if (snapShot.hasError) {
                      return Center(
                        child: Text(
                          "ERROR: ${snapShot.error}",
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (snapShot.hasData) {
                      List<CategoryModel> allCategoryData = snapShot.data ?? [];

                      return allCategoryData.isNotEmpty
                          ? ListView.builder(
                              itemCount: allCategoryData.length,
                              itemBuilder: (context, index) {
                                CategoryModel data = allCategoryData[index];
                                return Card(
                                  elevation: 4,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 26,
                                      backgroundImage: MemoryImage(data.image),
                                    ),
                                    title: Text(
                                      data.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.teal),
                                          onPressed: () {
                                            categoryController.text = data.name;
                                            controller.updateIndex();

                                            Get.bottomSheet(
                                              Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.all(16),
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20),
                                                  ),
                                                ),
                                                child: Form(
                                                  key: formKey,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Text(
                                                        "Update Category",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                            categoryController,
                                                        validator: (val) =>
                                                            val!.isEmpty
                                                                ? "Required"
                                                                : null,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: "Category",
                                                          hintText:
                                                              "Enter category...",
                                                          filled: true,
                                                          fillColor:
                                                              Colors.grey[200],
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            borderSide:
                                                                BorderSide.none,
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .teal),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Expanded(
                                                        child: GridView.builder(
                                                          gridDelegate:
                                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 4,
                                                            crossAxisSpacing:
                                                                10,
                                                            mainAxisSpacing: 10,
                                                          ),
                                                          itemCount:
                                                              categoryImage
                                                                  .length,
                                                          itemBuilder: (context,
                                                                  index) =>
                                                              GestureDetector(
                                                            onTap: () {
                                                              controller
                                                                  .changeIndex(
                                                                      index:
                                                                          index);
                                                            },
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                border:
                                                                    Border.all(
                                                                  color: (controller
                                                                              .categoryIndex ==
                                                                          index)
                                                                      ? Colors
                                                                          .teal
                                                                      : Colors
                                                                          .transparent,
                                                                ),
                                                                image:
                                                                    DecorationImage(
                                                                  image: AssetImage(
                                                                      categoryImage[
                                                                          index]),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Center(
                                                        child:
                                                            ElevatedButton.icon(
                                                          onPressed: () async {
                                                            if (formKey
                                                                    .currentState!
                                                                    .validate() &&
                                                                controller
                                                                        .categoryIndex !=
                                                                    null) {
                                                              String name =
                                                                  categoryController
                                                                      .text;

                                                              String assetPath =
                                                                  categoryImage[
                                                                      controller
                                                                          .categoryIndex!];

                                                              ByteData
                                                                  byteData =
                                                                  await rootBundle
                                                                      .load(
                                                                          assetPath);

                                                              Uint8List image =
                                                                  byteData
                                                                      .buffer
                                                                      .asUint8List();

                                                              CategoryModel
                                                                  model =
                                                                  CategoryModel(
                                                                id: data.id,
                                                                name: name,
                                                                image: image,
                                                                imageId: controller
                                                                    .categoryIndex!,
                                                              );

                                                              controller
                                                                  .updateCategory(
                                                                      model:
                                                                          model);

                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          },
                                                          icon: const Icon(
                                                            Icons.save,
                                                            color: Colors.white,
                                                          ),
                                                          label: const Text(
                                                            "Update",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.teal,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            controller.deleteCategory(
                                                id: allCategoryData[index].id);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text("No Category Available"),
                            );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

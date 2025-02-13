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
    final CategoryController controller = Get.put(CategoryController());
    controller.fetchCategory();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Category',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20, // Increased font size for app bar title
          ),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          _buildSearchBar(controller),
          const SizedBox(height: 16), // Increased spacing
          // Category List
          Expanded(
            child: GetBuilder<CategoryController>(
              builder: (context) {
                return FutureBuilder<List<CategoryModel>>(
                  future: controller.categoryList,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "ERROR: ${snapshot.error}",
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          "No Category Available",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      );
                    } else {
                      return _buildCategoryList(snapshot.data!, controller);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Search Bar Widget
  Widget _buildSearchBar(CategoryController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Increased padding
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(CupertinoIcons.search, color: Colors.teal, size: 24),
          hintText: 'Search',
          hintStyle: const TextStyle(fontSize: 16), // Increased hint text size
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20), // Better padding
        ),
        style: const TextStyle(fontSize: 16), // Increased text size
        onChanged: (value) => controller.searchCategory(search: value),
      ),
    );
  }

  // Category List Widget
  Widget _buildCategoryList(
      List<CategoryModel> categories, CategoryController controller) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16), // Added horizontal padding
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final CategoryModel data = categories[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8), // Adjusted margin
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Better padding
            leading: CircleAvatar(
              radius: 28, // Increased size
              backgroundImage: MemoryImage(data.image),
            ),
            title: Text(
              data.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18, // Increased font size
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.teal, size: 28), // Increased icon size
                  onPressed: () => _showUpdateCategoryBottomSheet(data, controller),
                ),
                const SizedBox(width: 8), // Added spacing between icons
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 28), // Increased icon size
                  onPressed: () => controller.deleteCategory(id: data.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Bottom Sheet for Updating Category
  void _showUpdateCategoryBottomSheet(
      CategoryModel data, CategoryController controller) {
    final TextEditingController categoryController =
        TextEditingController(text: data.name);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    Get.bottomSheet(
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20), // Increased padding
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Update Category",
                style: TextStyle(
                  fontSize: 22, // Increased font size
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16), // Increased spacing
              TextFormField(
                controller: categoryController,
                validator: (val) => val!.isEmpty ? "Required" : null,
                decoration: InputDecoration(
                  labelText: "Category",
                  labelStyle: const TextStyle(fontSize: 16), // Increased label size
                  hintText: "Enter category...",
                  hintStyle: const TextStyle(fontSize: 16), // Increased hint size
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.teal),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20), // Better padding
                ),
                style: const TextStyle(fontSize: 16), // Increased text size
              ),
              const SizedBox(height: 16), // Increased spacing
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12, // Increased spacing
                    mainAxisSpacing: 12, // Increased spacing
                  ),
                  itemCount: categoryImage.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => controller.changeIndex(index: index),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12), // Increased border radius
                        border: Border.all(
                          color: (controller.categoryIndex == index)
                              ? Colors.teal
                              : Colors.transparent,
                          width: 2, // Increased border width
                        ),
                        image: DecorationImage(
                          image: AssetImage(categoryImage[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16), // Increased spacing
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (formKey.currentState!.validate() &&
                        controller.categoryIndex != null) {
                      final String name = categoryController.text;
                      final String assetPath =
                          categoryImage[controller.categoryIndex!];
                      final ByteData byteData = await rootBundle.load(assetPath);
                      final Uint8List image = byteData.buffer.asUint8List();

                      final CategoryModel model = CategoryModel(
                        id: data.id,
                        name: name,
                        image: image,
                        imageId: controller.categoryIndex!,
                      );

                      controller.updateCategory(model: model);
                      Get.back();
                    }
                  },
                  icon: const Icon(Icons.save, color: Colors.white, size: 24), 
                  label: const Text(
                    "Update",
                    style: TextStyle(color: Colors.white, fontSize: 18), 
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
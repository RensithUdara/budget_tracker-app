import 'package:budget_tracker_app/controller/category_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/category_model.dart';

class AllCategory extends StatelessWidget {
  const AllCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryController controller = Get.put(CategoryController());
    controller.fetchCategory();

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(controller),
          const SizedBox(height: 16),
          Expanded(
            child: GetBuilder<CategoryController>(
              builder: (controller) => FutureBuilder<List<CategoryModel>>(
                future: controller.categoryList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return _buildErrorWidget(snapshot.error.toString());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildEmptyState();
                  }
                  return _buildCategoryList(snapshot.data!, controller);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Search Category',
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
      ),
      backgroundColor: Colors.teal,
      centerTitle: true,
    );
  }

  Widget _buildSearchBar(CategoryController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon:
              const Icon(CupertinoIcons.search, color: Colors.teal, size: 24),
          hintText: 'Search',
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        style: const TextStyle(fontSize: 16),
        onChanged: (value) => controller.searchCategory(search: value),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Text(
        "ERROR: $error",
        style: const TextStyle(color: Colors.red, fontSize: 16),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        "No Category Available",
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  Widget _buildCategoryList(
      List<CategoryModel> categories, CategoryController controller) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final CategoryModel data = categories[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: CircleAvatar(
                radius: 28, backgroundImage: MemoryImage(data.image)),
            title: Text(
              data.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            trailing: _buildTrailingIcons(data, controller),
          ),
        );
      },
    );
  }

  Widget _buildTrailingIcons(
      CategoryModel data, CategoryController controller) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.teal, size: 28),
          onPressed: () => _showUpdateCategoryBottomSheet(data, controller),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red, size: 28),
          onPressed: () => controller.deleteCategory(id: data.id),
        ),
      ],
    );
  }

  void _showUpdateCategoryBottomSheet(
      CategoryModel data, CategoryController controller) {
    final TextEditingController categoryController =
        TextEditingController(text: data.name);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Update Category",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                controller: categoryController,
                validator: (val) => val!.isEmpty ? "Required" : null,
                decoration: _inputDecoration("Category", "Enter category..."),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _updateCategory(
                    data, categoryController, controller, formKey),
                icon: const Icon(Icons.save, color: Colors.white, size: 24),
                label: const Text("Update",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.teal)),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    );
  }

  void _updateCategory(
      CategoryModel data,
      TextEditingController categoryController,
      CategoryController controller,
      GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
      // final updatedModel = data.copyWith(name: categoryController.text);
      //controller.updateCategory(model: updatedModel);
      Get.back();
    }
  }
}

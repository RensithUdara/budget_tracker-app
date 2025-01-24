import 'package:budget_tracker_app/components/all_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/category_component.dart';
import '../../components/all_spending.dart';
import '../../components/spending_component.dart';
import '../../controller/navigation_controller.dart';

class HomeScreen extends StatelessWidget {
  final NavigationController controller = Get.put(NavigationController());
  final PageController pageController = PageController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Budget Tracker',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {
              // Add search functionality
            },
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          controller.setIndex(index);
        },
        children: const [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: AllSpending(),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: SpendingComponent(),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: AllCategory(),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: CategoryComponent(),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: controller.screenIndex.value,
            onTap: (index) {
              controller.setIndex(index);
              pageController.jumpToPage(index);
            },
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.cases_sharp),
                label: 'All Spending',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.attach_money),
                label: 'Spending',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.balance),
                label: 'All Category',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: 'Category',
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new spending or category
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
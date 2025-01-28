import 'package:budget_tracker_app/helper/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/spending_model.dart';

class SpendingController extends GetxController {
  // Reactive state variables
  var spendingMode = Rx<String?>(null);
  var spendingDate = Rx<DateTime?>(null);
  var spendingIndex = Rx<int?>(null);
  var categoryId = 0.obs;
  var spendingList = Rx<Future<List<SpendingModel>>?>(null);

  SpendingController() {
    getSpendingData();
  }

  // Set spending index and category ID
  void setSpendingIndex({required int index, required int id}) {
    spendingIndex.value = index;
    categoryId.value = id;
  }

  // Set spending mode
  void setSpendingMode({String? mode}) {
    spendingMode.value = mode;
  }

  // Set spending date
  void setSpendingDate({required DateTime date}) {
    spendingDate.value = date;
  }

  // Reset all values to default
  void resetValues() {
    spendingMode.value = null;
    spendingDate.value = null;
    spendingIndex.value = null;
    categoryId.value = 0;
  }

  // Add a new spending
  Future<void> addSpendings({required SpendingModel model}) async {
    try {
      int? result = await DBHelper.dbHelper.insertSpendingData(model: model);
      if (result != null) {
        getSpendingData();
        Get.snackbar('Adding Spending', 'Spending Add Completed',
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            backgroundColor: Colors.green);
      } else {
        throw Exception('Failed to add spending');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add spending: $e',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red);
    }
  }

  // Fetch spending data
  void getSpendingData() {
    spendingList.value = DBHelper.dbHelper.fetchSpendingData();
  }

  // Update an existing spending
  Future<void> updateSpendings({required SpendingModel model}) async {
    try {
      int? res = await DBHelper.dbHelper.updateSpending(model: model);
      if (res != null) {
        getSpendingData();
        Get.snackbar('Updating Spending', 'Spending Update Completed',
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            backgroundColor: Colors.green);
      } else {
        throw Exception('Failed to update spending');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update spending: $e',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red);
    }
  }

  // Delete a spending
  Future<void> deleteSpendings({required int id}) async {
    try {
      int? res = await DBHelper.dbHelper.deleteSpending(id: id);
      if (res != null) {
        getSpendingData();
        Get.snackbar('Deleting Spending', 'Spending Delete Completed',
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            backgroundColor: Colors.green);
      } else {
        throw Exception('Failed to delete spending');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete spending: $e',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red);
    }
  }
}
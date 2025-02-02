import 'package:budget_tracker_app/components/spending_component.dart';
import 'package:budget_tracker_app/controller/spending_controller.dart';
import 'package:budget_tracker_app/helper/db_helper.dart';
import 'package:budget_tracker_app/model/spending_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllSpending extends StatelessWidget {
  const AllSpending({super.key});

  @override
  Widget build(BuildContext context) {
    final SpendingController controller = Get.put(SpendingController());
    controller.getSpendingData();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Spending',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: GetBuilder<SpendingController>(
        builder: (controller) {
          return FutureBuilder<List<SpendingModel>>(
            future: controller.spendingList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    "No spending records found.",
                    style: TextStyle(color: Colors.black87, fontSize: 18),
                  ),
                );
              }
              
              final spendingData = snapshot.data!;
              return ListView.builder(
                itemCount: spendingData.length,
                itemBuilder: (context, index) {
                  final data = spendingData[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ListTile(
                        leading: FutureBuilder(
                          future: DBHelper.dbHelper.getSpendingById(id: data.categoryId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return CircleAvatar(
                                backgroundImage: MemoryImage(snapshot.data!.image),
                                radius: 25,
                              );
                            } else {
                              return const CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.category, color: Colors.white),
                              );
                            }
                          },
                        ),
                        title: Text(
                          data.descripsion,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          "Date: ${data.date}",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        trailing: Text(
                          "Rs. ${data.amount}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        onTap: () => _showSpendingDetails(context, data, controller),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showSpendingDetails(
      BuildContext context, SpendingModel data, SpendingController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.teal[800],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.descripsion,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              "Amount: Rs. ${data.amount}",
              style: const TextStyle(fontSize: 22, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              "Date: ${data.date}",
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => controller.deleteSpendings(id: data.id),
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text("Delete", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.back();
                    // Implement update functionality if needed
                  },
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text("Edit", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

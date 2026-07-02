import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/riwayat_donasi_controller.dart';

class RiwayatDonasiView extends GetView<RiwayatDonasiController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Riwayat Donasi"), backgroundColor: Color(0xFF064635)),
      body: Obx(() => controller.riwayatList.isEmpty 
        ? Center(child: Text("Belum ada riwayat donasi"))
        : ListView.builder(
            itemCount: controller.riwayatList.length,
            itemBuilder: (context, index) {
              var item = controller.riwayatList[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text("Rp ${item['amount']}"),
                  subtitle: Text("Status: ${item['status']}"),
                  leading: Icon(Icons.volunteer_activism, color: Colors.green),
                ),
              );
            },
          )),
    );
  }
}
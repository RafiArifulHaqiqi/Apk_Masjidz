import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/laporan_controller.dart';

class LaporanView extends GetView<LaporanController> {
  const LaporanView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LaporanView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'LaporanView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

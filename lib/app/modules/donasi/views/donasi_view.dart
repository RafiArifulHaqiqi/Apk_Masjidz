import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/donasi_controller.dart';

class DonasiView extends GetView<DonasiController> {
  const DonasiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DonasiView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DonasiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

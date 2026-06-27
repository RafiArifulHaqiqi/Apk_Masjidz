import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Rx Variables (Reaktif)
  var currentTime = "".obs;
  var countdown = "".obs;
  var activePrayerName = "MEMUAT...".obs;
  var iqamahTime = "--:--".obs;

  // List Data dari Firebase
  var activities = <Map<String, dynamic>>[].obs;
  var announcements = <Map<String, dynamic>>[].obs;

  var prayerTimes = <String, String>{
    "SUBUH": "04:15",
    "DZUHUR": "11:45",
    "ASHAR": "15:05",
    "MAGHRIB": "17:40",
    "ISYA": "18:55"
  }.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startClock();
    fetchRealtimeJadwal();
    listenToFirebaseData();
  }

  void _startClock() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      currentTime.value = DateFormat('HH:mm:ss').format(now);
      _calculateNextPrayer();
    });
  }

  void _calculateNextPrayer() {
    final now = DateTime.now();
    final format = DateFormat("HH:mm");
    List<String> order = ["SUBUH", "DZUHUR", "ASHAR", "MAGHRIB", "ISYA"];
    bool found = false;

    for (String s in order) {
      if (prayerTimes[s] == null) continue;
      DateTime pTime = format.parse(prayerTimes[s]!);
      DateTime prayerDateTime =
          DateTime(now.year, now.month, now.day, pTime.hour, pTime.minute);

      if (prayerDateTime.isAfter(now)) {
        activePrayerName.value = s;

        // LOGIC IQAMAH: Tambahkan 10-15 menit dari jadwal sholat
        DateTime iqamahDT = prayerDateTime.add(const Duration(minutes: 10));
        iqamahTime.value = DateFormat("HH:mm").format(iqamahDT);

        Duration diff = prayerDateTime.difference(now);
        countdown.value = _formatDuration(diff);
        found = true;
        break;
      }
    }
    if (!found) activePrayerName.value = "SUBUH BESOK";
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  void listenToFirebaseData() {
    firestore.collection('activities').snapshots().listen((snapshot) {
      activities.value = snapshot.docs.map((doc) => doc.data()).toList();
    });
    firestore
        .collection('announcements')
        .orderBy('date')
        .snapshots()
        .listen((snapshot) {
      announcements.value = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> fetchRealtimeJadwal() async {
    try {
      var url = Uri.parse(
          "https://api.aladhan.com/v1/timingsByCity?city=Pemalang&country=Indonesia&method=2");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data']['timings'];
        prayerTimes.assignAll({
          "SUBUH": data["Fajr"],
          "DZUHUR": data["Dhuhr"],
          "ASHAR": data["Asr"],
          "MAGHRIB": data["Maghrib"],
          "ISYA": data["Isha"],
        });
      }
    } catch (e) {
      print("API Error");
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}

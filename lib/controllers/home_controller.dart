import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class HomeController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();

  var title = ''.obs;
  var counter = 0.obs;
  var remainder = 0.obs;
  var targetValue = 100.obs;
  var sound = true.obs;
  var vibrate = true.obs;

  var archive = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    preloadSound();
    // Preload sound to prevent delay
  }

  Future<void> preloadSound() async {
    await audioPlayer.setSourceAsset('sounds/popp.mp3'); // Preload sound
    await audioPlayer.setVolume(1.0);
  }

  Future<void> playClickSound() async {
    if (sound.value) {
      await audioPlayer.stop(); // Stop any previous playback
      await audioPlayer.setSourceAsset('sounds/popp.mp3'); // Set asset again
      await audioPlayer.resume(); // Play sound
    }
  }

  void incrementCounter(BuildContext context) async {
    if (counter.value >= targetValue.value) return;

    counter.value++;

    await playClickSound();

    if (vibrate.value && await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 50);
    }

    if (counter.value == remainder.value) {
      _showReminderDialog(context);
    }
  }

  void resetCounter() {
    counter.value = 0;
  }

  Future<void> openAddNew(BuildContext context) async {
    final result = await Navigator.pushNamed<Map<String, dynamic>>(
      context,
      '/add', // Assuming '/add' is the route for the AddNewScreen
    );

    if (result != null) {
      // Update the current counter values
      title.value = result['title'];
      counter.value = result['start'];
      remainder.value = result['remainder'];
      targetValue.value = result['target'];

      // Add the new counter to the archive
      archive.add({
        'title': title.value,
        'start': counter.value,
        'remainder': remainder.value,
        'target': targetValue.value,
        'note': result['note'] ?? '', // Ensure there's no null value for note
      });
    }
  }

  Future<void> openArchive(BuildContext context) async {
    final selected = await Navigator.pushNamed<Map<String, dynamic>>(
      context,
      '/archive',
      arguments: archive,
    );

    if (selected != null) {
      title.value = selected['title'];
      counter.value = selected['start'];
      remainder.value = selected['remainder'];
      targetValue.value = selected['target'];
    }
  }

  void _showReminderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Reminder Reached!'),
            content: Text(
              'You have reached the reminder count of ${remainder.value}.',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void setFromArchive(result) {}
}

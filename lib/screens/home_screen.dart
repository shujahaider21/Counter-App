import 'package:counter_app/controllers/archive_controller.dart';
import 'package:counter_app/screens/archive_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';
import 'package:counter_app/screens/add_new.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Obx(
          () => Column(
            children: [
              Text(
                controller.title.value,
                style: GoogleFonts.roboto(fontSize: 18),
              ),
              Text(
                'Reminder: ${controller.remainder.value}',
                style: GoogleFonts.roboto(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              // Open AddNewScreen when pressed and get the result
              final result = await Get.to(() => AddNewScreen());

              if (result != null) {
                // Update the current counter with the new data
                controller.title.value = result['title'];
                controller.counter.value = result['start'];
                controller.remainder.value = result['remainder'];
                controller.targetValue.value = result['target'];

                // Add the new counter to the archive
                controller.archive.add({
                  'title': result['title'],
                  'start': result['start'],
                  'remainder': result['remainder'],
                  'target': result['target'],
                  'note': result['note'],
                });
              }
            },
            child: const Icon(
              Icons.arrow_drop_down_circle_outlined,
              size: 50,
              color: Colors.green,
            ),
          ),

          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 10),
              Obx(
                () => LinearProgressIndicator(
                  value: (controller.counter.value /
                          controller.targetValue.value)
                      .clamp(0.0, 1.0),
                  backgroundColor: Colors.grey[800],
                  valueColor: const AlwaysStoppedAnimation(Colors.green),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('images/counter.png', height: 300),
                      Obx(
                        () => Positioned(
                          top: 38,
                          child: Text(
                            '${controller.counter.value}',
                            style: const TextStyle(
                              fontFamily: 'SevenSegment',
                              fontSize: 48,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 47,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => controller.incrementCounter(context),
                            borderRadius: BorderRadius.circular(45),
                            splashColor: Colors.white24,
                            highlightColor: Colors.transparent,
                            child: Container(
                              width: 95,
                              height: 95,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Obx(
                      () => IconButton(
                        icon: Icon(
                          controller.sound.value
                              ? Icons.volume_up
                              : Icons.volume_off,
                        ),
                        onPressed: () => controller.sound.toggle(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Ensure ArchiveController is initialized
                        Get.put(ArchiveController());

                        // Open ArchiveScreen when pressed
                        final result = await Get.to(
                          () => ArchiveScreen(archive: controller.archive),
                        );

                        if (result != null) {
                          controller.setFromArchive(
                            result,
                          ); // Update controller if something is selected
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                      ),
                      child: const Text('Archive'),
                    ),
                    Obx(
                      () => IconButton(
                        icon: Icon(
                          controller.vibrate.value
                              ? Icons.vibration
                              : Icons.vibration_outlined,
                        ),
                        onPressed: () => controller.vibrate.toggle(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
          Positioned(
            top: 276,
            left: MediaQuery.of(context).size.width / 2 - 96,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  borderRadius: BorderRadius.circular(40),
                  splashColor: Colors.green.withOpacity(0.3),
                  onTap: controller.resetCounter,
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(Icons.refresh, color: Colors.green, size: 35),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

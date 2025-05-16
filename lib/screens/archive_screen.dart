import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/archive_controller.dart';

class ArchiveScreen extends StatelessWidget {
  final List<Map<String, dynamic>> archive;

  ArchiveScreen({super.key, required this.archive});
  final ArchiveController controller = Get.find<ArchiveController>();

  @override
  Widget build(BuildContext context) {
    controller.loadArchive(archive);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('Archive', style: TextStyle(color: Colors.white)),
      ),
      body: Obx(
        () =>
            controller.archive.isEmpty
                ? const Center(
                  child: Text(
                    'No archived counters yet.',
                    style: TextStyle(color: Colors.white70),
                  ),
                )
                : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  itemCount: controller.archive.length,
                  itemBuilder: (context, i) {
                    final item = controller.archive[i];
                    final isSelected = i == controller.selectedIndex.value;

                    return GestureDetector(
                      onTap: () {
                        // Return the selected counter to the HomeScreen
                        Navigator.pop(context, item);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(8),
                          border:
                              isSelected
                                  ? Border.all(color: Colors.purple, width: 2)
                                  : null,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'] ?? '',
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Start: ${item['start']}    Reminder: ${item['remainder']}    Target: ${item['target']}',
                                    style: GoogleFonts.roboto(
                                      color: Colors.grey[400],
                                      fontSize: 12,
                                    ),
                                  ),
                                  if ((item['note'] as String).isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      item['note'],
                                      style: GoogleFonts.roboto(
                                        color: Colors.grey[500],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () => controller.deleteEntry(i),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ArchiveScreen extends StatefulWidget {
//   final List<Map<String, dynamic>> archive;
//   const ArchiveScreen({super.key, required this.archive});

//   @override
//   State<ArchiveScreen> createState() => _ArchiveScreenState();
// }

// class _ArchiveScreenState extends State<ArchiveScreen> {
//   int? _selectedIndex;

//   void _deleteEntry(int index) {
//     setState(() {
//       widget.archive.removeAt(index);
//       if (_selectedIndex != null) {
//         if (widget.archive.isEmpty) {
//           _selectedIndex = null;
//         } else if (_selectedIndex! >= widget.archive.length) {
//           _selectedIndex = widget.archive.length - 1;
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.close, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         centerTitle: true,
//         title: const Text('Archive', style: TextStyle(color: Colors.white)),
//       ),
//       body:
//           widget.archive.isEmpty
//               ? const Center(
//                 child: Text(
//                   'No archived counters yet.',
//                   style: TextStyle(color: Colors.white70),
//                 ),
//               )
//               : ListView.builder(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 10,
//                   horizontal: 16,
//                 ),
//                 itemCount: widget.archive.length,
//                 itemBuilder: (context, i) {
//                   final item = widget.archive[i];
//                   final isSelected = i == _selectedIndex;
//                   return GestureDetector(
//                     onTap: () => Navigator.pop(context, item),
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(vertical: 6),
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[900],
//                         borderRadius: BorderRadius.circular(8),
//                         border:
//                             isSelected
//                                 ? Border.all(color: Colors.purple, width: 2)
//                                 : null,
//                       ),
//                       child: Row(
//                         children: [
//                           // Counter info
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   item['title'] ?? '',
//                                   style: GoogleFonts.roboto(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   'Start: ${item['start']}    Reminder: ${item['remainder']}    Target: ${item['target']}',
//                                   style: GoogleFonts.roboto(
//                                     color: Colors.grey[400],
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                                 if ((item['note'] as String).isNotEmpty) ...[
//                                   const SizedBox(height: 6),
//                                   Text(
//                                     item['note'],
//                                     style: GoogleFonts.roboto(
//                                       color: Colors.grey[500],
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                 ],
//                               ],
//                             ),
//                           ),

//                           // Delete button
//                           IconButton(
//                             icon: const Icon(
//                               Icons.delete,
//                               color: Colors.redAccent,
//                             ),
//                             onPressed: () => _deleteEntry(i),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//     );
//   }
// }

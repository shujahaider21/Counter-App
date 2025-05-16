import 'package:get/get.dart';

class ArchiveController extends GetxController {
  var archive = <Map<String, dynamic>>[].obs;

  RxnInt selectedIndex = RxnInt();

  void deleteEntry(int index) {
    archive.removeAt(index);
    if (selectedIndex.value != null) {
      if (archive.isEmpty) {
        selectedIndex.value = null;
      } else if (selectedIndex.value! >= archive.length) {
        selectedIndex.value = archive.length - 1;
      }
    }
  }

  void loadArchive(List<Map<String, dynamic>> initialData) {
    archive.value = initialData;
  }
}

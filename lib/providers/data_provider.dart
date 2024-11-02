import 'package:flutter/foundation.dart';

class DataProvider with ChangeNotifier {
  List<Map<String, String>> _agendaItems = [
    {'title': 'Ujian Semester', 'date': '15 Sept 2024'},
    {'title': 'Rapat Guru', 'date': '20 Sept 2024'},
  ];
  
  List<Map<String, String>> _infoItems = [
    {'title': 'Pengumuman Libur', 'date': '10 Sept 2024'},
    {'title': 'Info Beasiswa', 'date': '12 Sept 2024'},
  ];
  
  List<Map<String, String>> _galleryItems = [
    {'title': 'Foto Kegiatan 1', 'date': '5 Sept 2024'},
    {'title': 'Foto Kegiatan 2', 'date': '8 Sept 2024'},
  ];

  List<Map<String, String>> get agendaItems => _agendaItems;
  List<Map<String, String>> get infoItems => _infoItems;
  List<Map<String, String>> get galleryItems => _galleryItems;

  void addAgendaItem(Map<String, String> item) {
    _agendaItems.add(item);
    notifyListeners();
  }

  void addInfoItem(Map<String, String> item) {
    _infoItems.add(item);
    notifyListeners();
  }

  void addGalleryItem(Map<String, String> item) {
    _galleryItems.add(item);
    notifyListeners();
  }

  void editAgendaItem(Map<String, String> oldItem, Map<String, String> newItem) {
    final index = _agendaItems.indexOf(oldItem);
    if (index != -1) {
      _agendaItems[index] = newItem;
      notifyListeners();
    }
  }

  void editInfoItem(Map<String, String> oldItem, Map<String, String> newItem) {
    final index = _infoItems.indexOf(oldItem);
    if (index != -1) {
      _infoItems[index] = newItem;
      notifyListeners();
    }
  }

  void editGalleryItem(Map<String, String> oldItem, Map<String, String> newItem) {
    final index = _galleryItems.indexOf(oldItem);
    if (index != -1) {
      _galleryItems[index] = newItem;
      notifyListeners();
    }
  }

  void deleteAgendaItem(Map<String, String> item) {
    _agendaItems.remove(item);
    notifyListeners();
  }

  void deleteInfoItem(Map<String, String> item) {
    _infoItems.remove(item);
    notifyListeners();
  }

  void deleteGalleryItem(Map<String, String> item) {
    _galleryItems.remove(item);
    notifyListeners();
  }
} 
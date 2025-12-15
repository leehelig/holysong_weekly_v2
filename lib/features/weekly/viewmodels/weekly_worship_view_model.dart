import 'package:flutter/foundation.dart';

import '../models/weekly_worship.dart';
import '../models/song_info.dart';
import '../services/weekly_worship_service.dart';

class WeeklyWorshipViewModel extends ChangeNotifier {
  final WeeklyWorshipService service;

  WeeklyWorshipViewModel(this.service);

  WeeklyWorship? _weekly;
  WeeklyWorship? get weekly => _weekly;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ---------------------------------------------
  // Task 26 — load(date)
  // ---------------------------------------------
  Future<void> load(String date) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _weekly = await service.load(date);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---------------------------------------------
  // Task 27 — subscribe(date)
  // ---------------------------------------------
  Stream<WeeklyWorship?> subscribe(String date) {
    return service.watch(date);
  }

  // ---------------------------------------------
  // Task 28 — saveDraft()
  // ---------------------------------------------
  Future<void> saveDraft() async {
    if (_weekly == null) return;

    _isSaving = true;
    notifyListeners();

    try {
      await service.saveDraft(_weekly!);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // ---------------------------------------------
  // Task 29 — publish()
  // ---------------------------------------------
  Future<void> publish() async {
    if (_weekly == null) return;

    _isSaving = true;
    notifyListeners();

    try {
      await service.publish(_weekly!);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // ---------------------------------------------
  // Task 30 — setAnnouncement
  // ---------------------------------------------
  void setAnnouncement(String value) {
    if (_weekly == null) return;
    _weekly = service.updateAnnouncement(_weekly!, value);
    notifyListeners();
  }

  // ---------------------------------------------
  // Task 31 — setSong
  // ---------------------------------------------
  void setSong(SongInfo song) {
    if (_weekly == null) return;
    _weekly = service.updateSong(_weekly!, song);
    notifyListeners();
  }

  // ---------------------------------------------
  // Task 32 — setAudio
  // ---------------------------------------------
  void setAudio(String part, List<String> urls) {
    if (_weekly == null) return;
    _weekly = service.updateAudio(_weekly!, part, urls);
    notifyListeners();
  }

  // ---------------------------------------------
  // Task 33 — setScore
  // ---------------------------------------------
  void setScore(String part, String? url) {
    if (_weekly == null) return;
    _weekly = service.updateScore(_weekly!, part, url);
    notifyListeners();
  }
}

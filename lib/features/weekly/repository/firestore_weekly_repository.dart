import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/weekly_worship.dart';
import 'weekly_repository.dart';

class FirestoreWeeklyRepository implements WeeklyRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CollectionReference get _col => _db.collection('weekly');

  @override
  Future<WeeklyWorship?> fetch(String date) async {
    final doc = await _col.doc(date).get();
    if (!doc.exists) return null;
    return WeeklyWorship.fromMap(doc.data() as Map<String, dynamic>);
  }

  @override
  Stream<WeeklyWorship?> watch(String date) {
    return _col.doc(date).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return WeeklyWorship.fromMap(snapshot.data() as Map<String, dynamic>);
    });
  }

  @override
  Future<void> save(WeeklyWorship weekly) async {
    final map = weekly.toMap()
      ..['updatedAt'] = DateTime.now().toIso8601String();
    await _col.doc(weekly.date).set(map, SetOptions(merge: true));
  }

  @override
  Future<String> uploadScorePdf({
    required String date,
    required String instrument,
    required Uint8List fileBytes,
  }) async {
    final ref =
        _storage.ref().child('scores/$date/$instrument.pdf');

    await ref.putData(
      fileBytes,
      SettableMetadata(contentType: 'application/pdf'),
    );

    return await ref.getDownloadURL();
  }
}

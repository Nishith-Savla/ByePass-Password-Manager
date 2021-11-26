import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:password_manager/models/password_entry.dart';

class DataRepository {
  late final CollectionReference collection;
  DataRepository({String collectionName = "entries"}) {
    collection = FirebaseFirestore.instance.collection(collectionName);
  }

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<DocumentReference> addEntry(PasswordEntry entry) {
    return collection.add(entry.toJson());
  }

  void updateEntry(PasswordEntry entry) async {
    await collection.doc(entry.referenceId).update(entry.toJson());
  }

  void deleteEntry(PasswordEntry entry) async {
    await collection.doc(entry.referenceId).delete();
  }
}

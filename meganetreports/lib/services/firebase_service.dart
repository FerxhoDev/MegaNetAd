import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getIncidents() async {
  List incidents = [];
  CollectionReference collectionReferenceIncidents = db.collection('incidentes');

  QuerySnapshot querySnapshotIncidents = await collectionReferenceIncidents.get();

  querySnapshotIncidents.docs.forEach((element) {
    incidents.add(element.data());
  });

  return incidents;
} 


final currentTime = Timestamp.now();
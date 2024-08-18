import 'package:cloud_firestore/cloud_firestore.dart';

class incidentModel {
  String cliente;
  String tipo;
  String descripcion;
  String comentario;
  bool estado;
  Timestamp fecha;

  incidentModel(
      {required this.cliente,
      required this.tipo,
      required this.descripcion,
      required this.comentario,
      required this.estado,
      required this.fecha
      }
    );
}

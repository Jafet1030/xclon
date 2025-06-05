/* 

Ayudara en la formateación de fechas y horas.
Convertira de timestamp a string

Por ejemplo si la fecha es: Junio 3, 2025, 16:00
La funcion la cambiara a string: "2025-06-03 16:00" 

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  DateTime now = DateTime.now();
  Duration diff = now.difference(dateTime);

  if (diff.inDays == 0) {
    return 'Hoy';
  } else if (diff.inDays == 1) {
    return 'Ayer';
  } else if (diff.inDays < 7) {
    return 'Hace ${diff.inDays} días';
  } else if (diff.inDays < 30) {
    return 'Hace ${diff.inDays ~/ 7 + 1} semanas';
  }  else {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }
}
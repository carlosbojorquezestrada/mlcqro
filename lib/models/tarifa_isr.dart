import 'package:flutter_application_4/models/tarifa_detalle.dart';

class TarifaISR {
  TarifaISR({required this.nTarifaISR, required this.sNombreTarifa});

  int nTarifaISR;
  String sNombreTarifa;

  List<TarifaDetalle> tarifaDetalle = [];
}

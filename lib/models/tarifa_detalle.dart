import 'package:flutter_application_4/models/periodo.dart';

class TarifaDetalle {
  TarifaDetalle(
      {required this.nTarifaDetalleID,
      required this.dLimiteInferior,
      required this.dLimiteSuperior,
      required this.dCuotaFija,
      required this.dSobreexedente,
      required this.periodo});

  int nTarifaDetalleID;
  double dLimiteInferior;
  double dLimiteSuperior;
  double dCuotaFija;
  double dSobreexedente;

  Periodo periodo;
}

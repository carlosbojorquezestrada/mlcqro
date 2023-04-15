import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';

class TextEditingControllerProvideer extends ChangeNotifier {
  GlobalKey keyIngresoIVA = GlobalKey();
  GlobalKey keyIngresoSinIVA = GlobalKey();
  GlobalKey keyDeduccionIVA = GlobalKey();
  GlobalKey keyDeduccionSinIVA = GlobalKey();
  GlobalKey keyCoeficienteUtilidad = GlobalKey();
  GlobalKey keyDeduccionCiega = GlobalKey();
  GlobalKey keyBaseGravable = GlobalKey();
  GlobalKey keyImpuestoCausado = GlobalKey();
  GlobalKey keyIvaPorPagar = GlobalKey();
  GlobalKey keyTotalPagar = GlobalKey();
  GlobalKey keyRazonSocial = GlobalKey();
  GlobalKey keyRFC = GlobalKey();
  //GlobalKey<ComboBoxState> keyTipoPersona = GlobalKey<ComboBoxState>();
  GlobalKey keyRetencion = GlobalKey();
  String sTipoPersona = '';

  void setTipoPersona(String sTipoPersona) {
    sTipoPersona = sTipoPersona;
    notifyListeners();
  }
}

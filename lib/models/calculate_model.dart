import 'package:flutter/material.dart';

class Calculo extends ChangeNotifier {
  double _ingresoIVA = 0;
  double _ingresoSinIVA = 0;
  double _deduccionIVA = 0;
  double _deduccionSinIVA = 0;
  double _baseGravable = 0;
  double _coeficienteUtilidad = 0;
  double _deduccionCiega = 0;
  int _periodo = 0;

  double _impuestoCausado = 0;
  double _totIVAporPagar = 0;

  double _totlPagar = 0;
  double _retencionISR = 0;
  double _retencionIVA = 0;

  bool _retencionImpuesto = false;

  double get getIngresoIVA => _ingresoIVA;
  double get getingresoSinIVA => _ingresoSinIVA;
  double get getDeduccionIVA => _deduccionIVA;
  double get getDeduccionSinIVA => _deduccionSinIVA;
  double get getCoeficienteUtilidad => _coeficienteUtilidad;
  double get getDeduccionCiega => _deduccionCiega;
  double get getBaseGravable => _baseGravable;
  double get getimpuestoCausado => _impuestoCausado;
  double get getIVAporPagar => _totIVAporPagar;
  double get gettotalPagar => _totlPagar;
  bool get getRetencionImpuesto => _retencionImpuesto;
  double get getRetencionISR => _retencionISR;
  double get getRetencionIVA => _retencionIVA;
  int get getPeriodo => _periodo;

  Calculo get getCalculo {
    Calculo calculo = Calculo();
    calculo.setIngresoIVA(_ingresoIVA);
    calculo.setIngresoSinIVA(_ingresoSinIVA);
    calculo.setDeduccionIVA(_deduccionIVA);
    calculo.setDeduccionSinIVA(_deduccionSinIVA);
    calculo.setCoeficienteUtilidad(_coeficienteUtilidad);
    calculo.setDeduccionCiega(_deduccionCiega);
    calculo.setImpuestoCausado(_impuestoCausado);
    calculo.setTotIVAporPagar(_totIVAporPagar);
    calculo.setTotalPagar(_totlPagar);
    calculo.setBaseGravable(_baseGravable);
    calculo.setPeriodo(_periodo);
    calculo.setRetencionImpuesto(_retencionImpuesto);
    return calculo;
  }

  resetCalculo() {
    _ingresoIVA = 0;
    _ingresoSinIVA = 0;
    _deduccionIVA = 0;
    _deduccionSinIVA = 0;
    _coeficienteUtilidad = 0;
    _deduccionCiega = 0;
    _impuestoCausado = 0;
    _totIVAporPagar = 0;
    _totlPagar = 0;
    _retencionISR = 0;
    _retencionIVA = 0;
    _retencionImpuesto = false;
    _baseGravable = 0;
    _periodo = 0;
    notifyListeners();
  }

  setIngresoIVA(double ingresoIVA) {
    _ingresoIVA = ingresoIVA;
    notifyListeners();
  }

  setPeriodo(int nPeriodoID) {
    _periodo = nPeriodoID;
    notifyListeners();
  }

  setIngresoSinIVA(double ingresoSinIVA) {
    _ingresoSinIVA = ingresoSinIVA;
    notifyListeners();
  }

  setDeduccionIVA(double deduccionIVA) {
    _deduccionIVA = deduccionIVA;
    notifyListeners();
  }

  setDeduccionSinIVA(double deduccionSinIVA) {
    _deduccionSinIVA = deduccionSinIVA;
    notifyListeners();
  }

  setCoeficienteUtilidad(double coeficienteUtilidad) {
    _coeficienteUtilidad = coeficienteUtilidad;
    notifyListeners();
  }

  setDeduccionCiega(double deduccionCiega) {
    _deduccionCiega = deduccionCiega;
    notifyListeners();
  }

  setImpuestoCausado(double impuestoCausado) {
    _impuestoCausado = impuestoCausado;
    notifyListeners();
  }

  setTotIVAporPagar(double dIVAporPagar) {
    _totIVAporPagar = dIVAporPagar;
    notifyListeners();
  }

  setTotalPagar(double totalPagar) {
    _totlPagar = totalPagar;
    notifyListeners();
  }

  setRetencionISR(double retencionISR) {
    _retencionISR = retencionISR;
    notifyListeners();
  }

  setRetencionIVA(double retencionIVA) {
    _retencionIVA = retencionIVA;
    notifyListeners();
  }

  setRetencionImpuesto(bool retencionImpuesto) {
    _retencionImpuesto = retencionImpuesto;
    notifyListeners();
  }

  setBaseGravable(double baseGraduable) {
    _baseGravable = baseGraduable;
    notifyListeners();
  }
  // void calculaBaseGravable() {
  //   _baseGraduable =
  //       (_ingresoIVA + _ingresoSinIVA) - (_deduccionIVA + _deduccionSinIVA);

  //   notifyListeners();
  // }
}

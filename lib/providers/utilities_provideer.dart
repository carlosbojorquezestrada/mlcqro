import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/subsidio_model.dart';
import 'package:flutter_application_4/models/tarifa_ISR.dart';
import '../models/cliente_model.dart';
import '../models/connection.dart';
import '../models/periodo.dart';
import '../models/regimen_model.dart';

class UtilitiesProvider extends ChangeNotifier {
  UtilitiesProvider() {
    obtenerPeriodos();
    obtenerTarifas();
    obtenerSubsidio();
  }

  final List<String> personas = ["Física", "Moral"];
  List<Regimen> regimenes = [];
  List<TarifaISR> tarifas = [];
  List<SubcidioEmpleo> subcidio = [];

  int tarifaSeleccionada = 0;

  int bodyNum = 1;
  int longitudRFC = 13;

  String _tipoPersonaSeleccionado = '';
  String _regimenSeleccionado = '';

  Regimen _regimenSelected = Regimen(nRegimenID: 0, sNombreRegimen: '');

  List<String> get items => personas;
  List<Regimen> get itemsRegimen => regimenes;
  List<Periodo> periodos = [];
  Regimen get regimenSelected => _regimenSelected;

  String get tipoPersonaSeleccionado => _tipoPersonaSeleccionado;
  String get regimenSeleccionado => _regimenSeleccionado;

  double height = 0;

  get getHeight => height;

  setHeight(int size) {
    height = size.toDouble() * 490.0;
    notifyListeners();
  }

  setBodyNum(int num) {
    bodyNum = num;
    notifyListeners();
  }

  obtenerRegimenes(int nTipoPersonaID) async {
    Connection connection = Connection();
    regimenes = await connection.obtenerTiposRegimen(nTipoPersonaID);
    notifyListeners();
  }

  obtenerPeriodos() async {
    Connection connection = Connection();
    periodos = await connection.obtenerPeriodos();
    notifyListeners();
  }

  obtenerSubsidio() async {
    Connection connection = Connection();
    subcidio = await connection.obtenerSubsidio();
    notifyListeners();
  }

  obtenerTarifaDetallle(TarifaISR tarifa, int index) async {
    Connection connection = Connection();
    tarifa.tarifaDetalle =
        await connection.obtenerTarifaDetallle(tarifa.nTarifaISR);

    tarifaSeleccionada = index;

    notifyListeners();
  }

  obtenerTarifas() async {
    Connection connection = Connection();
    tarifas = await connection.obtenerTarifas();
    notifyListeners();
  }

  void setSelectedItem(String tipoPersona) {
    _tipoPersonaSeleccionado = tipoPersona;
    notifyListeners();
  }

  void setRegimen(String sNombreRegimen, int nRegimenID) {
    _regimenSeleccionado = sNombreRegimen;
    _regimenSelected =
        Regimen(nRegimenID: nRegimenID, sNombreRegimen: sNombreRegimen);
    // _regimenSelected = regimenes
    //     .firstWhere((element) => element.nRegimenID.toString() == regimen);
    notifyListeners();
  }

  setRFCLongitud(int longitud) {
    longitudRFC = longitud;
    notifyListeners();
  }
}

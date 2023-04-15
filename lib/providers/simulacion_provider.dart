import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/connection.dart';

import 'package:flutter_application_4/models/simulacion_model.dart';

//import '../models/cliente_model.dart';

class SimulacionProvider extends ChangeNotifier {
  final List<List<Simulacion>> _listSimulacion = [];

  int _sizeLista = 0;

  get sizeLista => _sizeLista;
  int _nivel = 0;

  get listSimulacion => _listSimulacion;
  get nivel => _nivel;

  setClienteSimulacion(Simulacion simulacion, int nivel) async {
    if (_listSimulacion.isEmpty) {
      _listSimulacion.add([simulacion]);
    } else if (nivel == 100) {
      _listSimulacion[0].add(simulacion);
    } else {
      if (nivel + 1 == _listSimulacion.length) {
        _listSimulacion.add([simulacion]);
      } else {
        _listSimulacion[nivel + 1].add(simulacion);
      }
    }

    if (nivel != 100) {
      late Simulacion simulacionPadre;
      for (var lista in _listSimulacion) {
        final index = lista.indexWhere((element) =>
            element.cliente.nClientID == simulacion.padre.nClientID);
        if (index != -1) {
          simulacionPadre = lista[index];
          break;
        }
      }

      simulacionPadre.calculo.setDeduccionIVA(
          simulacionPadre.calculo.getDeduccionIVA +
              simulacion.calculo.getIngresoIVA);

      Connection connection = Connection();

      final result = await connection.calcularImpuesto(
          simulacionPadre.calculo.getCalculo,
          simulacionPadre.cliente.nRegimenID,
          simulacionPadre.cliente.nTipoPersona);

      for (final row in result.rows) {
        simulacionPadre.calculo.setImpuestoCausado(
            double.parse(row.colByName("dImpuestoCausado")!));

        simulacionPadre.calculo
            .setTotIVAporPagar(double.parse(row.colByName("IVAporPagar")!));

        simulacionPadre.calculo
            .setTotalPagar(double.parse(row.colByName("totalPagar")!));

        simulacionPadre.calculo
            .setBaseGravable(double.parse(row.colByName("baseGravable")!));

        if (simulacionPadre.calculo.getRetencionImpuesto) {
          simulacionPadre.calculo
              .setRetencionIVA(double.parse(row.colByName("IVARetencion")!));
          if (simulacionPadre.cliente.nTipoPersona == 1) {
            simulacionPadre.calculo
                .setRetencionISR(double.parse(row.colByName("ISRRetencion")!));
          }
        }
      }
    }

    _sizeLista = _listSimulacion.length;

    simulacion.cliente.simulado = true;
    notifyListeners();
  }

  eliminarClienteSimulacion(Simulacion simulacion) async {
    for (var list in _listSimulacion) {
      list.removeWhere((element) =>
          element.cliente.nClientID == simulacion.cliente.nClientID);
    }

    var vacios = [];
    int index = 0;
    for (var element in _listSimulacion) {
      if (element.isEmpty) {
        vacios.add(index);
      }
      index++;
    }

    vacios.sort();
    vacios.reversed;

    for (var index in vacios) {
      _listSimulacion.removeAt(index);
    }

    late Simulacion simulacionPadre;
    for (var lista in _listSimulacion) {
      final index = lista.indexWhere(
          (element) => element.cliente.nClientID == simulacion.padre.nClientID);
      if (index != -1) {
        simulacionPadre = lista[index];
        break;
      }
    }

    if (listSimulacion.length > 1) {
      simulacionPadre.calculo.setDeduccionIVA(
          simulacionPadre.calculo.getDeduccionIVA -
              simulacion.calculo.getIngresoIVA);

      Connection connection = Connection();

      final result = await connection.calcularImpuesto(
          simulacionPadre.calculo.getCalculo,
          simulacionPadre.cliente.nRegimenID,
          simulacionPadre.cliente.nTipoPersona);

      for (final row in result.rows) {
        simulacionPadre.calculo.setImpuestoCausado(
            double.parse(row.colByName("dImpuestoCausado")!));

        simulacionPadre.calculo
            .setTotIVAporPagar(double.parse(row.colByName("IVAporPagar")!));

        simulacionPadre.calculo
            .setTotalPagar(double.parse(row.colByName("totalPagar")!));

        simulacionPadre.calculo
            .setBaseGravable(double.parse(row.colByName("baseGravable")!));

        if (simulacionPadre.calculo.getRetencionImpuesto) {
          simulacionPadre.calculo
              .setRetencionIVA(double.parse(row.colByName("IVARetencion")!));
          if (simulacionPadre.cliente.nTipoPersona == 1) {
            simulacionPadre.calculo
                .setRetencionISR(double.parse(row.colByName("ISRRetencion")!));
          }
        }
      }
    }

    simulacion.cliente.simulado = false;
    _sizeLista = _listSimulacion.length;
    notifyListeners();
  }

  agregarNivelSimulacion() {
    _nivel++;
    notifyListeners();
  }
}

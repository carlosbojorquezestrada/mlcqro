import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/connection.dart';

import '../models/cliente_model.dart';

class ClienteProvider extends ChangeNotifier {
  ClienteProvider() {
    setClientes();
  }

  List<Cliente> _clientes = [];

  int _size = 0;
  Cliente _clienteSeleccionado = Cliente(
      nClientID: 0,
      sRazonSocial: '',
      nRegimenID: 0,
      sNombreRegimen: '',
      sRFC: '',
      nTipoPersona: 0,
      sTipoPersona: '',
      simulado: false);

  get clientes => _clientes;
  get clienteseleccionado => _clienteSeleccionado;
  get size => _size;

  setClientes() async {
    Connection conn = Connection();
    _clientes = await conn.obtenerClintes();
    _size = _clientes.length;
    notifyListeners();
  }

  setClienteSeleccionado(Cliente cliente) {
    _clienteSeleccionado = cliente;
    notifyListeners();
  }
}

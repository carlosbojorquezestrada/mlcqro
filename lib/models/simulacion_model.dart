import 'package:flutter_application_4/models/calculate_model.dart';
import 'package:flutter_application_4/models/cliente_model.dart';

class Simulacion {
  Simulacion(
      {required this.cliente, required this.calculo, required this.padre});

  Cliente cliente;
  Calculo calculo;
  Cliente padre;

  get getCliente => cliente;
  get getCalculo => calculo;
  get getPadre => padre;
}

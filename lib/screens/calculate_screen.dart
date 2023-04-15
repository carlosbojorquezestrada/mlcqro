import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_4/models/periodo.dart';
import 'package:flutter_application_4/providers/cliente_provider.dart';
import 'package:flutter_application_4/providers/simulacion_provider.dart';
import 'package:flutter_application_4/providers/text_controller.dart';
import 'package:flutter_application_4/providers/utilities_provideer.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/calculate_model.dart';
import '../models/cliente_model.dart';
import '../models/connection.dart';
import '../models/simulacion_model.dart';

final format = NumberFormat.currency(locale: "es_MX", symbol: "");

const textStyleHeader =
    TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey);

class ScaffoldPageCalculate extends StatelessWidget {
  const ScaffoldPageCalculate({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerCalculo = Provider.of<Calculo>(context);
    final providerCliente = Provider.of<ClienteProvider>(context);
    final provierUtilities = Provider.of<UtilitiesProvider>(context);
    final providersimulacion = Provider.of<SimulacionProvider>(context);

    return ScaffoldPage.scrollable(
      header: Row(
        children: [
          const Expanded(
            flex: 15,
            child: PageHeader(
              title: Text("Cálculo de impuestos"),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(
                  FluentIcons.add_space_after,
                  size: 30,
                ),
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => ContentDialog(
                      constraints: const BoxConstraints(maxWidth: 400),
                      //title: const Text('agregar cliente'),
                      content: const SeleccionCaculoWidget(),
                      actions: [
                        FilledButton(
                          child: const Text('Aceptar'),
                          onPressed: () async {
                            await providersimulacion.setClienteSimulacion(
                                Simulacion(
                                    cliente:
                                        providerCliente.clienteseleccionado,
                                    calculo: providerCalculo.getCalculo,
                                    padre: Cliente(
                                        nClientID: 0,
                                        sRazonSocial: '',
                                        nRegimenID: 0,
                                        sNombreRegimen: '',
                                        sRFC: '',
                                        nTipoPersona: 0,
                                        sTipoPersona: '',
                                        simulado: false)),
                                100);

                            provierUtilities
                                .setHeight(providersimulacion.sizeLista);

                            if (context.mounted) {
                              Navigator.pop(context, 'User deleted file');
                            }
                          },
                        ),
                        Button(
                          child: const Text('Cancelar'),
                          onPressed: () {
                            Navigator.pop(context, 'User deleted file');
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      children: [
        SizedBox(
          height: provierUtilities.height,
          child: ListView.builder(
            itemCount: providersimulacion.sizeLista,
            itemBuilder: (context, index) {
              return SimulacionWidget(
                clientesSimulacion: providersimulacion.listSimulacion[index],
                nivel: index,
              );
            },
          ),
        ),
      ],
    );
  }
}

class SeleccionCaculoWidget extends StatelessWidget {
  const SeleccionCaculoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final providerCalculo = Provider.of<Calculo>(context);
    final providerText = Provider.of<TextEditingControllerProvideer>(context);
    final providerCliente = Provider.of<ClienteProvider>(context);
    final provierUtilities = Provider.of<UtilitiesProvider>(context);

    TextEditingController controllerBaseGrabable = TextEditingController(
        text: format.format(providerCalculo.getBaseGravable));

    TextEditingController controllerImpuesto = TextEditingController(
        text: format.format(providerCalculo.getimpuestoCausado));

    TextEditingController controllerIVAporPagar = TextEditingController(
        text: format.format(providerCalculo.getIVAporPagar));

    TextEditingController controllerTotalPagar = TextEditingController(
        text: format.format(providerCalculo.gettotalPagar));

    TextEditingController controllerRetencionIVA = TextEditingController(
        text: format.format(providerCalculo.getRetencionIVA));

    TextEditingController controllerRetencionISR = TextEditingController(
        text: format.format(providerCalculo.getRetencionISR));

    List<TextInputFormatter> inputFormatters = [
      FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)')),
    ];
    return Column(
      children: [
        InfoLabel(
          label: "Clientes",
          labelStyle: textStyleHeader,
          child: ComboBox<String>(
            isExpanded: true,
            placeholder: const Text('Selecciona cliente'),
            value: providerCliente.clienteseleccionado.nClientID.toString(),
            items: providerCliente.clientes.map<ComboBoxItem<String>>((e) {
              return ComboBoxItem<String>(
                value: e.nClientID.toString(),
                child: Text(e.sRazonSocial),
              );
            }).toList(),
            onChanged: (value) {
              List<Cliente> clientes = providerCliente.clientes;
              Cliente cliente = clientes.firstWhere(
                  (element) => element.nClientID.toString() == value);

              providerCliente.setClienteSeleccionado(cliente);

              provierUtilities.setRegimen(
                  cliente.sNombreRegimen, cliente.nRegimenID);

              providerCalculo.resetCalculo();
              controllerRetencionIVA.text = '';
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 5, left: 5),
          child: Row(
            children: [
              Text(providerCliente.clienteseleccionado.sTipoPersona,
                  style: textStyleHeader)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5, left: 5),
          child: Row(
            children: [
              Text(
                provierUtilities.regimenSelected.sNombreRegimen,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              )
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 3, bottom: 3),
          child: Divider(),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InfoLabel(
                  label: provierUtilities.regimenSelected.nRegimenID == 6 ||
                          provierUtilities.regimenSelected.nRegimenID == 12
                      ? "Salario"
                      : "Ingreso IVA",
                  labelStyle: textStyleHeader,
                  child: TextBox(
                    key: providerText.keyIngresoIVA,
                    inputFormatters: inputFormatters,
                    //controller: controllerIngresoIVA,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        providerCalculo.setIngresoIVA(double.parse(value));
                      }
                    },
                  ),
                ),
              ),
            ),
            provierUtilities.regimenSelected.nRegimenID == 6 ||
                    provierUtilities.regimenSelected.nRegimenID == 12
                ? const SizedBox.shrink()
                : Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InfoLabel(
                        label: "Ingreso sin IVA",
                        labelStyle: textStyleHeader,
                        child: TextBox(
                          key: providerText.keyIngresoSinIVA,
                          inputFormatters: inputFormatters,
                          //controller: controllerIngresoSinIVA,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              providerCalculo
                                  .setIngresoSinIVA(double.parse(value));
                            }
                          },
                        ),
                      ),
                    ),
                  ),
          ],
        ),
        // const Padding(
        //   padding: EdgeInsets.only(top: 3, bottom: 3),
        //   child: Divider(),
        // ),
        provierUtilities.regimenSelected.nRegimenID == 6 ||
                provierUtilities.regimenSelected.nRegimenID == 12
            ? const SizedBox.shrink()
            : Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InfoLabel(
                        label: "Deduccion IVA",
                        labelStyle: textStyleHeader,
                        child: TextBox(
                          key: providerText.keyDeduccionIVA,
                          inputFormatters: inputFormatters,
                          //controller: controllerDeduccionIVA,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              providerCalculo
                                  .setDeduccionIVA(double.parse(value));
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InfoLabel(
                        label: "Deduccion sin IVA",
                        labelStyle: textStyleHeader,
                        child: TextBox(
                          key: providerText.keyDeduccionSinIVA,
                          inputFormatters: inputFormatters,
                          //controller: controllerDeduccionSinIVA,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              providerCalculo
                                  .setDeduccionSinIVA(double.parse(value));
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        const Padding(
          padding: EdgeInsets.only(top: 3, bottom: 3),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              provierUtilities.regimenSelected.nRegimenID == 3
                  ? Expanded(
                      child: InfoLabel(
                        label: "Periodo",
                        labelStyle: textStyleHeader,
                        child: ComboBox<String>(
                          isExpanded: true,
                          placeholder: const Text('Selecciona periodo'),
                          value: providerCalculo.getPeriodo.toString(),
                          items: provierUtilities.periodos
                              .map<ComboBoxItem<String>>((e) {
                            return ComboBoxItem<String>(
                              value: e.nPeriodoID.toString(),
                              child: Text('${e.nAgno}/${e.nMes}'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            List<Periodo> periodos = provierUtilities.periodos;
                            Periodo periodo = periodos.firstWhere((element) =>
                                element.nPeriodoID.toString() == value);

                            providerCalculo.setPeriodo(periodo.nPeriodoID);
                          },
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
        Row(
          children: [
            provierUtilities.regimenSelected.nRegimenID == 9
                ? Flexible(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InfoLabel(
                          label: "Coeficiente utilidad",
                          labelStyle: textStyleHeader,
                          child: TextBox(
                            key: providerText.keyCoeficienteUtilidad,
                            inputFormatters: inputFormatters,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                providerCalculo.setCoeficienteUtilidad(
                                    double.parse(value));
                              }
                            },
                          ),
                        )),
                  )
                : const SizedBox.shrink(),
            provierUtilities.regimenSelected.nRegimenID == 4
                ? Flexible(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InfoLabel(
                          label: "Deducción ciega",
                          labelStyle: textStyleHeader,
                          child: TextBox(
                            key: providerText.keyDeduccionCiega,
                            inputFormatters: inputFormatters,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                providerCalculo
                                    .setDeduccionCiega(double.parse(value));
                              }
                            },
                          ),
                        )),
                  )
                : const SizedBox.shrink(),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InfoLabel(
                  label: "Base gravable",
                  labelStyle: textStyleHeader,
                  child: TextBox(
                    enabled: false,
                    key: providerText.keyBaseGravable,
                    controller: controllerBaseGrabable,
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InfoLabel(
                  label: "ISR",
                  labelStyle: textStyleHeader,
                  child: TextBox(
                    enabled: false,
                    key: providerText.keyImpuestoCausado,
                    controller: controllerImpuesto,
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InfoLabel(
                  label: "IVA",
                  labelStyle: textStyleHeader,
                  child: TextBox(
                    enabled: false,
                    key: providerText.keyIvaPorPagar,
                    controller: controllerIVAporPagar,
                  ),
                ),
              ),
            ),
          ],
        ),
        providerCalculo.getRetencionImpuesto
            ? Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InfoLabel(
                        label: "ISR retención",
                        labelStyle: textStyleHeader,
                        child: TextBox(
                          enabled: false,
                          //key: providerText.keyImpuestoCausado,
                          controller: controllerRetencionISR,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InfoLabel(
                        label: "IVA retención",
                        labelStyle: textStyleHeader,
                        child: TextBox(
                          enabled: false,
                          //key: providerText.keyIvaPorPagar,
                          controller: controllerRetencionIVA,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InfoLabel(
                  label: "Total a pagar",
                  labelStyle: textStyleHeader,
                  child: TextBox(
                    enabled: false,
                    key: providerText.keyTotalPagar,
                    controller: controllerTotalPagar,
                  ),
                ),
              ),
            ),
            (provierUtilities.regimenSelected.nRegimenID == 3 &&
                        providerCliente.clienteseleccionado.nTipoPersona ==
                            1) ||
                    (provierUtilities.regimenSelected.nRegimenID == 9 &&
                        providerCliente.clienteseleccionado.nTipoPersona == 2)
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InfoLabel(
                      label: 'Retención',
                      labelStyle: textStyleHeader,
                      child: ToggleSwitch(
                        key: providerText.keyRetencion,
                        checked: providerCalculo.getRetencionImpuesto,
                        onChanged: (value) {
                          providerCalculo.setRetencionImpuesto(value);
                        },
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            IconButton(
              icon: const Icon(FluentIcons.calculated_table, size: 30),
              onPressed: () async {
                Connection connection = Connection();

                final result = await connection.calcularImpuesto(
                    providerCalculo.getCalculo,
                    provierUtilities.regimenSelected.nRegimenID,
                    providerCliente.clienteseleccionado.nTipoPersona);

                for (final row in result.rows) {
                  providerCalculo.setImpuestoCausado(
                      double.parse(row.colByName("dImpuestoCausado")!));

                  providerCalculo.setTotIVAporPagar(
                      double.parse(row.colByName("IVAporPagar")!));

                  providerCalculo.setTotalPagar(
                      double.parse(row.colByName("totalPagar")!));

                  providerCalculo.setBaseGravable(
                      double.parse(row.colByName("baseGravable")!));

                  if (providerCalculo.getRetencionImpuesto) {
                    providerCalculo.setRetencionIVA(
                        double.parse(row.colByName("IVARetencion")!));
                    if (providerCliente.clienteseleccionado.tipoPersona == 1) {
                      providerCalculo.setRetencionISR(
                          double.parse(row.colByName("ISRRetencion")!));
                    }
                  }
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

class SimulacionWidget extends StatelessWidget {
  SimulacionWidget(
      {super.key, required this.clientesSimulacion, required this.nivel});

  final List<Simulacion> clientesSimulacion;
  final ScrollController controller = ScrollController();
  final int nivel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 470,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
          PointerDeviceKind.mouse,
          //PointerDeviceKind.trackpad
        }),
        child: ListView.builder(
          itemCount: clientesSimulacion.length,
          controller: controller,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return ChildrenWiddget(
              simulacion: clientesSimulacion[index],
              nivel: nivel,
            );
          },
        ),
      ),
    );
  }
}

class ChildrenWiddget extends StatelessWidget {
  const ChildrenWiddget(
      {Key? key, required this.simulacion, required this.nivel})
      : super(key: key);

  final Simulacion simulacion;
  final int nivel;

  @override
  Widget build(BuildContext context) {
    final providerSimulacion = Provider.of<SimulacionProvider>(context);
    final providerCliente = Provider.of<ClienteProvider>(context);
    final providerCalculo = Provider.of<Calculo>(context);
    final providerUtilities = Provider.of<UtilitiesProvider>(context);

    TextEditingController ingresoIVA = TextEditingController(
        text: simulacion.calculo.getIngresoIVA.toString());

    TextEditingController ingresoSinIVA = TextEditingController(
        text: simulacion.calculo.getingresoSinIVA.toString());

    TextEditingController deduccionIVA = TextEditingController(
        text: simulacion.calculo.getDeduccionIVA.toString());

    TextEditingController deduccionSinIVA = TextEditingController(
        text: simulacion.calculo.getDeduccionSinIVA.toString());

    TextEditingController isr = TextEditingController(
        text: simulacion.calculo.getimpuestoCausado.toString());

    TextEditingController iva = TextEditingController(
        text: simulacion.calculo.getIVAporPagar.toString());

    TextEditingController totalPagar = TextEditingController(
        text: simulacion.calculo.gettotalPagar.toString());

    TextEditingController baseGrabable = TextEditingController(
        text: simulacion.calculo.getBaseGravable.toString());

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, right: 10.0),
      child: SizedBox(
        width: 300,
        child: Card(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 0),
                    child: Text(
                      simulacion.cliente.sTipoPersona,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, bottom: 5),
                    child: Text(
                      simulacion.cliente.sNombreRegimen,
                      style: textStyleHeader,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 0, bottom: 20),
                    child: Divider(),
                  ),
                  ListTile(
                    title: Text(simulacion.cliente.sRFC,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700)),
                    subtitle: Text(
                      simulacion.cliente.sRazonSocial,
                      maxLines: 1,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: IconButton(
                      icon: const Icon(FluentIcons.delete),
                      onPressed: () async {
                        await providerSimulacion
                            .eliminarClienteSimulacion(simulacion);
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InfoLabel(
                        label: 'Ingreso IVA',
                        labelStyle: textStyleHeader,
                        child: TextBox(
                          controller: ingresoIVA,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InfoLabel(
                        label: 'Ingreso sin IVA',
                        labelStyle: textStyleHeader,
                        child: TextBox(
                          controller: ingresoSinIVA,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: InfoLabel(
                        label: 'Deduccion IVA',
                        labelStyle: textStyleHeader,
                        child: TextBox(
                          controller: deduccionIVA,
                          placeholder: 'Deduccion IVA',
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: InfoLabel(
                        label: "Deducción sin IVA",
                        labelStyle: textStyleHeader,
                        child: TextBox(
                          controller: deduccionSinIVA,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InfoLabel(
                        label: 'Base gravable',
                        labelStyle: textStyleHeader,
                        child: TextBox(
                          controller: baseGrabable,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Divider(),
              ),
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: InfoLabel(
                          label: 'ISR',
                          labelStyle: textStyleHeader,
                          child: TextBox(
                            controller: isr,
                          )),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: InfoLabel(
                        label: "IVA",
                        labelStyle: textStyleHeader,
                        child: TextBox(
                          controller: iva,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InfoLabel(
                        label: 'Total a Pagar',
                        labelStyle: textStyleHeader,
                        child: TextBox(controller: totalPagar),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      FluentIcons.add_space_after,
                      size: 20,
                    ),
                    onPressed: () async {
                      await newMethod(
                          context,
                          providerCalculo,
                          providerSimulacion,
                          providerCliente,
                          providerUtilities);
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Object?> newMethod(
      BuildContext context,
      Calculo providerCalculo,
      SimulacionProvider providerSimulacion,
      ClienteProvider providerCliente,
      UtilitiesProvider providerUtilities) {
    return showDialog(
      // context: context,
      context: context,
      builder: (context) => ContentDialog(
        constraints: const BoxConstraints(maxWidth: 400),
        //title: const Text('agregar cliente'),
        content: const SeleccionCaculoWidget(),
        actions: [
          FilledButton(
            child: const Text('Aceptar'),
            onPressed: () async {
              await providerSimulacion.setClienteSimulacion(
                Simulacion(
                    cliente: providerCliente.clienteseleccionado,
                    calculo: providerCalculo.getCalculo,
                    padre: simulacion.cliente),
                nivel,
              );

              providerUtilities.setHeight(providerSimulacion.sizeLista);
              if (context.mounted) Navigator.pop(context, 'User deleted file');
            },
          ),
          Button(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.pop(context, 'User deleted file');
            },
          ),
        ],
      ),
    );
  }
}

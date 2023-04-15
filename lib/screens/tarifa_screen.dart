import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_application_4/models/tarifa_detalle.dart';
import 'package:flutter_application_4/providers/utilities_provideer.dart';
import 'package:flutter_application_4/screens/tarifa_detalle.dart';
import 'package:provider/provider.dart';

class ScaffoldPageTarifaISR extends StatelessWidget {
  const ScaffoldPageTarifaISR({super.key});

  @override
  Widget build(BuildContext context) {
    final utilities = Provider.of<UtilitiesProvider>(context);

    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Tarifa ISR')),
      children: [
        // Button(
        //   child: Text('data'),
        //   onPressed: () {
        //     utilities.setBodyNum(2);
        //   },
        // ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Tarifas para el impuesto sobre la renta (ISR)',
                style: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: utilities.tarifas.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Card(
                    child: ListTile(
                      leading: const Icon(FluentIcons.list, size: 25),
                      title: Text(utilities.tarifas[index].sNombreTarifa),
                      //subtitle: Text('$index'),
                      trailing: IconButton(
                          icon: const Icon(FluentIcons.down),
                          onPressed: () => utilities.obtenerTarifaDetallle(
                              utilities.tarifas[index], index)),
                    ),
                  ),
                ),
              ),
            ),
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tarifa ISR'),
                  SizedBox(
                    height: 500,
                    child: ListView.builder(
                      itemCount: utilities.tarifas[utilities.tarifaSeleccionada]
                          .tarifaDetalle.length,
                      itemBuilder: (context, index) {
                        return TarifaDetalleWidget(
                            tarifaDetalle: utilities
                                .tarifas[utilities.tarifaSeleccionada]
                                .tarifaDetalle[index]);
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}

class TarifaDetalleWidget extends StatelessWidget {
  const TarifaDetalleWidget({
    required this.tarifaDetalle,
    super.key,
  });

  final TarifaDetalle tarifaDetalle;

  @override
  Widget build(BuildContext context) {
    TextEditingController dLimiteInferior =
        TextEditingController(text: tarifaDetalle.dLimiteInferior.toString());

    TextEditingController dLimiteSuperior =
        TextEditingController(text: tarifaDetalle.dLimiteSuperior.toString());

    TextEditingController dCuotaFija =
        TextEditingController(text: tarifaDetalle.dCuotaFija.toString());

    TextEditingController dSobreexedente =
        TextEditingController(text: tarifaDetalle.dSobreexedente.toString());

    TextEditingController sPeriodo = TextEditingController(
        text: '${tarifaDetalle.periodo.nAgno}/${tarifaDetalle.periodo.nMes}');

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: TextBox(
              controller: dLimiteInferior,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: TextBox(controller: dLimiteSuperior),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: TextBox(
              controller: dCuotaFija,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: TextBox(controller: dSobreexedente),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: TextBox(controller: sPeriodo),
          ),
        ),
      ],
    );
  }
}

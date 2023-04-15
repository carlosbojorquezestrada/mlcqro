import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_application_4/models/subsidio_model.dart';
import 'package:flutter_application_4/providers/utilities_provideer.dart';
import 'package:provider/provider.dart';

class ScaffoldPageSubsidio extends StatelessWidget {
  const ScaffoldPageSubsidio({super.key});

  @override
  Widget build(BuildContext context) {
    final utilities = Provider.of<UtilitiesProvider>(context);

    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Tarifa subsidio')),
      children: [
        SizedBox(
          height: 500,
          width: 500,
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const EncabezadoWidget(),
                SizedBox(
                  height: 400,
                  width: 400,
                  child: ListView.builder(
                    itemCount: utilities.subcidio.length,
                    itemBuilder: (context, index) {
                      return SubsidioEmpleoWidget(
                          subsidio: utilities.subcidio[index]);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class EncabezadoWidget extends StatelessWidget {
  const EncabezadoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var style = const TextStyle(fontSize: 15, fontWeight: FontWeight.w700);
    return SizedBox(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Row(
          children: [
            Expanded(
                child: Text(
              'Limite inferior',
              style: style,
              textAlign: TextAlign.center,
            )),
            Expanded(
                child: Text(
              'Limite superior',
              style: style,
              textAlign: TextAlign.center,
            )),
            Expanded(
                child: Text(
              'Subsidio',
              style: style,
              textAlign: TextAlign.center,
            )),
          ],
        ),
      ),
    );
  }
}

class SubsidioEmpleoWidget extends StatelessWidget {
  const SubsidioEmpleoWidget({super.key, required this.subsidio});

  final SubcidioEmpleo subsidio;

  @override
  Widget build(BuildContext context) {
    TextEditingController dLimiteInferior =
        TextEditingController(text: subsidio.dLimiteInferior.toString());

    TextEditingController dLimiteSuperior =
        TextEditingController(text: subsidio.dLimiteSuperior.toString());

    TextEditingController dCuotaFija =
        TextEditingController(text: subsidio.dSubsidio.toString());

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: TextBox(
              controller: dLimiteInferior,
              textAlign: TextAlign.right,
              readOnly: true,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: TextBox(
              controller: dLimiteSuperior,
              textAlign: TextAlign.right,
              readOnly: true,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: TextBox(
              controller: dCuotaFija,
              textAlign: TextAlign.right,
              readOnly: true,
            ),
          ),
        ),
      ],
    );
  }
}

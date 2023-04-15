import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_application_4/models/connection.dart';
import 'package:flutter_application_4/providers/cliente_provider.dart';

import '../models/cliente_model.dart';
import '../providers/text_controller.dart';
import '../providers/utilities_provideer.dart';

import 'package:provider/provider.dart';

List<String> persona = ["Física", "Moral"];

class ScaffoldPageClients extends StatelessWidget {
  const ScaffoldPageClients({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clientesProvaider = Provider.of<ClienteProvider>(context);

    return ScaffoldPage.withPadding(
      header: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              flex: 25,
              child: SizedBox(
                //color: Colors.red,
                width: 500,
                child: PageHeader(
                  title: Text("Listado de clientes"),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(FluentIcons.add),
                onPressed: () {
                  showContentDialog(context);
                  context.read<UtilitiesProvider>().setSelectedItem('');
                },
              ),
            )
          ],
        ),
      ),
      content: ListView.builder(
        itemCount: clientesProvaider.size,
        itemBuilder: (BuildContext context, int index) {
          Cliente cliente = clientesProvaider.clientes[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Card(
              child: ListTile(
                leading: const Icon(FluentIcons.user_window),
                title: Text(cliente.sRFC),
                subtitle: Text(cliente.sRazonSocial),
                trailing: IconButton(
                  icon: const Icon(FluentIcons.edit),
                  onPressed: () {},
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  showContentDialog(BuildContext context) async {
    final providerText =
        Provider.of<TextEditingControllerProvideer>(context, listen: false);

    TextEditingController controllerRFC = TextEditingController();
    TextEditingController controllerRazonSocial = TextEditingController();

    await showDialog<String>(
      context: context,
      builder: (context) => ContentDialog(
        constraints: const BoxConstraints(maxWidth: 750),
        title: const Text('Registrar contribuyente'),
        content: Column(
          children: [
            ComboBox(
              //key: providerText.keyTipoPersona,
              value: context.watch<UtilitiesProvider>().tipoPersonaSeleccionado,
              isExpanded: true,
              placeholder: const Text("Selecciona tipo de persona"),
              items: context
                  .read<UtilitiesProvider>()
                  .items
                  .map<ComboBoxItem<String>>((e) {
                return ComboBoxItem(value: e, child: Text(e));
              }).toList(),
              onChanged: (value) {
                context
                    .read<UtilitiesProvider>()
                    .setSelectedItem(value.toString());

                context
                    .read<UtilitiesProvider>()
                    .setRFCLongitud(value.toString() == 'Física' ? 13 : 12);

                context
                    .read<UtilitiesProvider>()
                    .obtenerRegimenes(value.toString() == 'Física' ? 1 : 2);
              },
            ),
            const SizedBox(height: 5),
            TextBox(
              key: providerText.keyRFC,
              controller: controllerRFC,
              placeholder: 'RFC',
              expands: false,
              maxLength: context.watch<UtilitiesProvider>().longitudRFC,
            ),
            const SizedBox(height: 5),
            TextBox(
              //header: 'Nombre',
              key: providerText.keyRazonSocial,
              controller: controllerRazonSocial,
              placeholder: 'Razón social',
              expands: false,
            ),
            const SizedBox(height: 5),
            ComboBox(
              isExpanded: true,
              value: context.watch<UtilitiesProvider>().regimenSeleccionado,
              placeholder: const Text("Selecciona tipo de régimen"),
              items: context
                  .read<UtilitiesProvider>()
                  .regimenes
                  .map<ComboBoxItem<String>>((e) {
                return ComboBoxItem(
                    value: e.nRegimenID.toString(),
                    child: Text(e.sNombreRegimen));
              }).toList(),
              onChanged: (value) => context
                  .read<UtilitiesProvider>()
                  .setRegimen('', int.parse(value ?? '')),
            ),
          ],
        ),
        actions: [
          Button(
            child: const Text('Aceptar'),
            onPressed: () async {
              if (controllerRFC.text.isEmpty) {
                const InfoBar(
                  title: Text("Error"),
                  content: Text('Ingresa el RFC'),
                  severity: InfoBarSeverity.warning,
                );
                return;
              }

              if (controllerRazonSocial.text.isEmpty) {}

              var tipoPersona =
                  context.read<UtilitiesProvider>().tipoPersonaSeleccionado ==
                          'Física'
                      ? 1
                      : 2;

              Connection connection = Connection();
              bool bInsertado = await connection.insertaCliente(Cliente(
                  nClientID: 0,
                  sRazonSocial: controllerRazonSocial.text,
                  sRFC: controllerRFC.text,
                  nRegimenID: context
                      .read<UtilitiesProvider>()
                      .regimenSelected
                      .nRegimenID,
                  sNombreRegimen: '',
                  nTipoPersona: tipoPersona,
                  sTipoPersona:
                      tipoPersona == 1 ? 'Persona Física' : 'Persona Moral',
                  simulado: false));

              if (bInsertado) {
                if (context.mounted) {
                  context.read<ClienteProvider>().setClientes();
                }
              }

              if (context.mounted) Navigator.pop(context, 'User deleted file');
            },
          ),
          FilledButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context, 'User canceled dialog'),
          ),
        ],
      ),
    );
  }
}

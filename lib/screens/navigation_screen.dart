import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_application_4/screens/subsidio_screen.dart';
import 'package:flutter_application_4/screens/tarifa_detalle.dart';
import 'package:flutter_application_4/providers/utilities_provideer.dart';
import 'package:flutter_application_4/screens/calculate_screen.dart';
import 'package:flutter_application_4/screens/tarifa_screen.dart';
import 'package:provider/provider.dart';

import '../providers/test_provider.dart';
import 'cliente_screen.dart';

class NavigationViewPage extends StatelessWidget {
  const NavigationViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TestProvider>(context);
    final utilities = Provider.of<UtilitiesProvider>(context);

    return NavigationView(
      appBar: const NavigationAppBar(title: Text("MLCQRO CALC")),
      pane: NavigationPane(
        selected: provider.selectedPane,
        onChanged: (value) {
          provider.setSelectedPane(value);
        },
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.folder_list),
            title: const Text('Clientes'),
            infoBadge: const InfoBadge(source: Text('8')),
            body: const ScaffoldPageClients(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.calculated_table),
            title: const Text("Cálculo"),
            body: const ScaffoldPageCalculate(),
          ),
        ],
        footerItems: [
          PaneItemExpander(
            title: const Text("Configuración"),
            icon: const Icon(FluentIcons.settings),
            body: const SizedBox.shrink(),
            items: [
              PaneItem(
                title: const Text("ISR"),
                icon: const Icon(FluentIcons.page_list),
                body: utilities.bodyNum == 1
                    ? const ScaffoldPageTarifaISR()
                    : const Detalle(),
              ),
              PaneItem(
                  title: const Text("Subsidio"),
                  icon: const Icon(FluentIcons.page_list),
                  body: const ScaffoldPageSubsidio())
            ],
          ),
        ],
      ),
    );
  }
}

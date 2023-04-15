import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_application_4/providers/utilities_provideer.dart';
import 'package:provider/provider.dart';

class Detalle extends StatelessWidget {
  const Detalle({super.key});

  @override
  Widget build(BuildContext context) {
    final utilities = Provider.of<UtilitiesProvider>(context);

    return Column(
      children: [
        const Text('data'),
        Button(
          child: const Text('data'),
          onPressed: () {
            utilities.setBodyNum(1);
          },
        )
      ],
    );
  }
}

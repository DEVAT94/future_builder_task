import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController controller = TextEditingController();
  Future<String>? _cityStringFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              spacing: 32,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Postleitzahl",
                  ),
                  controller: controller,
                ),
                OutlinedButton(
                  onPressed: () {
                    final zip = controller.text.trim();
                    _cityStringFuture = getCityFromZip(zip);
                  },
                  child: const Text("Suche"),
                ),
                const SizedBox(height: 16),
                _cityStringFuture == null
                    ? const Text("Ergebnis: Noch keine PLZ gesucht")
                    : FutureBuilder<String>(
                        future: _cityStringFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text("Fehler: ${snapshot.error}");
                          } else if (snapshot.hasData) {
                            return Text("Ergebnis: ${snapshot.data}");
                          } else {
                            return const Text("Unbekannte Stadt");
                          }
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<String> getCityFromZip(String zip) async {
    // simuliere Dauer der Datenbank-Anfrage
    await Future.delayed(const Duration(seconds: 3));

    if (zip.isEmpty) {
      throw 'Postleitzahl darf nicht leer sein';
    }

    switch (zip) {
      case "10115":
        return 'Berlin';
      case "20095":
        return 'Hamburg';
      case "80331":
        return 'München';
      case "50667":
        return 'Köln';
      case "60311":
      case "60313":
        return 'Frankfurt am Main';
      default:
        return 'Unbekannte Stadt';
    }
  }
}

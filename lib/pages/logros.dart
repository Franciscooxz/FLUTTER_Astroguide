import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:astroguide_flutter/services/logros_service.dart';
import 'package:get_storage/get_storage.dart';

class LogrosPage extends StatelessWidget {
  const LogrosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var storage = GetStorage();
    var token = storage.read('token');
    final Future<List<dynamic>> _logrosDataFuture =
        LogrosService.getLogros(token);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logros'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<dynamic>>(
          future: _logrosDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final List<dynamic> logrosData = snapshot.data!;

              return ListView.builder(
                itemCount: logrosData.length,
                itemBuilder: (context, index) {
                  final logro = logrosData[index];

                  return itemProfile(
                    logro['Nombre_del_Logro'] ?? 'Sin nombre',
                    logro['Rareza'] ?? 'Sin rareza',
                    CupertinoIcons.star,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: const Color.fromARGB(255, 104, 51, 155).withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        trailing: const Icon(Icons.rocket_launch, color: Colors.grey),
      ),
    );
  }
}

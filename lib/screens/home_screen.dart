import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyectproducts/controllers/person_controllers.dart';
import 'package:proyectproducts/models/client.dart';
import 'edit_client_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final PersonController personController = Get.put(PersonController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController serviceKindController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 64, 255),
                Color.fromARGB(255, 3, 168, 245)
              ],
            ),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.fitness_center_outlined,
                  size: 30,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  "GymGuard", // Título principal
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    letterSpacing: 1.5,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.5),
            Text(
              "Client List", // Subtítulo
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 1.2,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () {
                  // Aquí verificamos si es administrador o cliente
                  return ListView.builder(
                    itemCount: personController.getClientList().length,
                    itemBuilder: (context, index) {
                      // Usamos getClientList() o getAdminList() dependiendo del rol
                      var person = personController
                          .getClientList()[index]; // o getAdminList()

                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        elevation: 13,
                        shadowColor: const Color.fromARGB(182, 0, 115, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 16.0),
                          title: Text(
                            person.name,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 2, 0, 147),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Phone Number: ${person.nPhone}',
                                  style: const TextStyle(fontSize: 16)),
                              Text('License: ${person.license}',
                                  style: const TextStyle(fontSize: 16)),
                              Text('Type of Service: ${person.serviceKind}',
                                  style: const TextStyle(fontSize: 16)),
                              Text(
                                  'Date of Entry: ${person.dateEntry.toLocal().toString().split(' ')[0]}',
                                  style: const TextStyle(fontSize: 16)),
                              Obx(
                                () {
                                  return Text(
                                    person.remainingTime.value.isNotEmpty
                                        ? person.remainingTime.value
                                        : 'Ticket service activated',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            person.serviceKind.toLowerCase() ==
                                                    'monthly'
                                                ? Colors.red
                                                : const Color.fromARGB(
                                                    255, 36, 199, 178),
                                        fontWeight: FontWeight.bold),
                                  );
                                },
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Color.fromARGB(255, 33, 61, 243)),
                                onPressed: () {
                                  Get.to(() => EditClientScreen(
                                      client: person, index: index));
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  personController
                                      .deleteClient(index); // o deleteAdmin()
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: licenseController,
                    decoration: InputDecoration(
                      labelText: 'License',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: serviceKindController,
                    decoration: InputDecoration(
                        labelText: 'Type of Service (monthly/ticket)',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30))),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty &&
                          phoneController.text.isNotEmpty &&
                          licenseController.text.isNotEmpty &&
                          serviceKindController.text.isNotEmpty) {
                        // Agregar el cliente
                        personController.addClient(
                          Client(
                            name: nameController.text,
                            nPhone: phoneController.text,
                            license: licenseController.text,
                            password: passwordController
                                .text, // Asegúrate de tener este campo en tu formulario
                            serviceKind: serviceKindController.text,
                            dateEntry:
                                DateTime.now(), // Fecha de entrada actual
                            remainingTime: RxString(
                                '0 days'), // Asignando un valor por defecto para el tiempo restante
                          ),
                        );
                        // Limpiar los campos
                        nameController.clear();
                        phoneController.clear();
                        licenseController.clear();
                        serviceKindController.clear();
                      } else {
                        Get.snackbar(
                          'Error',
                          'Please complete all fields',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    child: const Text('Add Customer'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

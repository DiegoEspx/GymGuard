import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyectproducts/models/client.dart'; // Cambiado a Client
import 'package:proyectproducts/controllers/person_controllers.dart';

class EditClientScreen extends StatelessWidget {
  final Client client; // Cambiado a Client
  final int index;

  EditClientScreen({super.key, required this.client, required this.index});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController serviceKindController = TextEditingController();
  final TextEditingController passwordController =
      TextEditingController(); // Agregado

  // Marcar remainingTime como final
  final RxString remainingTime = ''.obs; // Agregado y ahora final

  final PersonController personController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Inicializando los controladores con los datos del cliente
    nameController.text = client.name;
    phoneController.text = client.nPhone;
    licenseController.text = client.license;
    serviceKindController.text = client.serviceKind;
    passwordController.text = client.password; // Inicializa el password
    remainingTime.value =
        client.remainingTime.value; // Inicializa el remainingTime

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Client'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de texto para el nombre
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 10),

            // Campo de texto para el teléfono
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 10),

            // Campo de texto para la cédula
            TextFormField(
              controller: licenseController,
              decoration: InputDecoration(
                labelText: 'License',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 10),

            // Campo de texto para el tipo de servicio
            TextFormField(
              controller: serviceKindController,
              decoration: InputDecoration(
                labelText: 'Type of Service',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 10),

            // Campo de texto para el password
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
              obscureText: true, // Para ocultar la contraseña
            ),
            const SizedBox(height: 20),

            // Botón para guardar los cambios
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Llamamos al método editClient para actualizar la lista de clientes
                  personController.editClient(
                    index,
                    Client(
                      name: nameController.text,
                      nPhone: phoneController.text,
                      license: licenseController.text,
                      password: passwordController.text, // Pasamos el password
                      serviceKind: serviceKindController.text,
                      dateEntry:
                          client.dateEntry, // No cambiamos la fecha de entrada
                      remainingTime: remainingTime, // Pasamos el remainingTime
                    ),
                  );
                  Get.back(); // Volver a la pantalla anterior
                },
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

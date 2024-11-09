import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:proyectproducts/models/admin.dart';
import 'package:proyectproducts/models/client.dart'; // Ahora estamos usando Client

class PersonController extends GetxController {
  final box = GetStorage(); // Instancia de GetStorage
  var admins = <Admin>[].obs; // Lista de administradores
  var clients = <Client>[].obs; // Lista de clientes

  @override
  void onInit() {
    super.onInit();
    loadUsers(); // Cargar administradores y clientes al iniciar
  }

  // Método para guardar administradores y clientes en el almacenamiento local
  void saveUsers() {
    List<Map<String, dynamic>> adminList =
        admins.map((admin) => admin.toJson()).toList();
    List<Map<String, dynamic>> clientList =
        clients.map((client) => client.toJson()).toList();

    box.write('admins', adminList);
    box.write('clients', clientList);
  }

  // Método para cargar administradores y clientes del almacenamiento local
  void loadUsers() {
    List<dynamic> storedAdmins = box.read('admins') ?? [];
    List<dynamic> storedClients = box.read('clients') ?? [];

    admins.assignAll(storedAdmins.map((data) => Admin.fromJson(data)).toList());
    clients
        .assignAll(storedClients.map((data) => Client.fromJson(data)).toList());
  }

  // Método para agregar un administrador
  void addAdmin(Admin admin) {
    admins.add(admin);
    saveUsers(); // Guardar después de agregar un administrador
  }

  // Método para agregar un cliente
  void addClient(Client client) {
    clients.add(client);
    saveUsers(); // Guardar después de agregar un cliente
  }

  // Método para eliminar un administrador
  void deleteAdmin(int index) {
    admins.removeAt(index);
    saveUsers(); // Guardar después de eliminar un administrador
  }

  // Método para eliminar un cliente
  void deleteClient(int index) {
    clients.removeAt(index);
    saveUsers(); // Guardar después de eliminar un cliente
  }

  // Método para verificar si un administrador está conectado (basado en la license)
  bool isAdmin(String license) {
    return admins.any((admin) =>
        admin.license ==
        license); // Verifica si la license pertenece a un administrador
  }

  // Método para verificar si un cliente está conectado (basado en la license)
  bool isClient(String license) {
    return clients.any((client) =>
        client.license ==
        license); // Verifica si la license pertenece a un cliente
  }

  // Método para obtener solo los clientes
  List<Client> getClientList() {
    return clients;
  }

  // Método para obtener solo los administradores
  List<Admin> getAdminList() {
    return admins;
  }

  // Método para editar un cliente en la lista
  void editClient(int index, Client updatedClient) {
    clients[index] = updatedClient; // Reemplazar el cliente en la lista
    saveUsers(); // Guardar después de editar
  }

  // Calcular tiempo restante
  Map<String, int> calculateRemainingTime(Client client) {
    final now = DateTime.now();
    final endDate =
        client.dateEntry.add(const Duration(days: 30)); // Fecha final
    final timeDifference = endDate.difference(now);

    int remainingDays = timeDifference.inDays;
    int remainingHours = timeDifference.inHours % 24;
    int remainingMinutes = timeDifference.inMinutes % 60;
    int remainingSeconds = timeDifference.inSeconds % 60;

    return {
      'days': remainingDays,
      'hours': remainingHours,
      'minutes': remainingMinutes,
      'seconds': remainingSeconds
    };
  }

  // Actualizar tiempo restante cada segundo
  void startTimer(Client client) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      // Verificamos si el cliente sigue siendo parte de la lista
      if (clients.contains(client)) {
        var remaining = calculateRemainingTime(client);
        client.remainingTime.value =
            'Time remaining: ${remaining['days']}d ${remaining['hours']}h ${remaining['minutes']}m ${remaining['seconds']}s';

        // Si el tiempo ha expirado, actualizamos el estado del cliente y cancelamos el timer
        if ((remaining['days'] ?? 0) <= 0 &&
            (remaining['hours'] ?? 0) <= 0 &&
            (remaining['minutes'] ?? 0) <= 0 &&
            (remaining['seconds'] ?? 0) <= 0) {
          client.remainingTime.value =
              'Expired'; // Usar .value para actualizar el RxString
          saveUsers(); // Guardar después de marcar como expirado
          timer.cancel();
        }
      } else {
        // Si el cliente ya no está en la lista, cancelamos el temporizador
        timer.cancel();
      }
    });
  }
}

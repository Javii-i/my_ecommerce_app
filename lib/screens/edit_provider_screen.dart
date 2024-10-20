import 'package:flutter/material.dart';
import 'package:my_ecommerce_app/services/api_service.dart';

class EditProviderScreen extends StatefulWidget {
  final Map proveedor;

  EditProviderScreen({required this.proveedor});

  @override
  _EditProviderScreenState createState() => _EditProviderScreenState();
}

class _EditProviderScreenState extends State<EditProviderScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mailController = TextEditingController();

  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.proveedor['provider_name'];
    lastNameController.text = widget.proveedor['provider_last_name'];
    mailController.text = widget.proveedor['provider_mail'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Proveedor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Apellido'),
            ),
            TextField(
              controller: mailController,
              decoration: InputDecoration(labelText: 'Correo Electrónico'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _editarProveedor();
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  // Método para editar el proveedor
  void _editarProveedor() async {
    try {
      await apiService.editarProveedor({
        'provider_id': widget.proveedor['provider_id'],
        'provider_name': nameController.text,
        'provider_last_name': lastNameController.text,
        'provider_mail': mailController.text,
        'provider_state': 'Activo',
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Proveedor actualizado con éxito')),
      );
      Navigator.pop(context); // Vuelve a la lista
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el proveedor')),
      );
    }
  }
}

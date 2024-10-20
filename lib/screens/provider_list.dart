import 'package:flutter/material.dart';
import 'package:my_ecommerce_app/services/api_service.dart';

class ProviderListScreen extends StatefulWidget {
  @override
  _ProviderListScreenState createState() => _ProviderListScreenState();
}

class _ProviderListScreenState extends State<ProviderListScreen> {
  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Proveedores'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: apiService.listarProveedores(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No se encontraron proveedores'));
          }

          final proveedores = snapshot.data!;

          return ListView.builder(
            itemCount: proveedores.length,
            itemBuilder: (context, index) {
              final proveedor = proveedores[index];

              return ListTile(
                title: Text('${proveedor['provider_name']} ${proveedor['provider_last_name']}'),
                subtitle: Text('${proveedor['provider_mail']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Navegar a la pantalla de edición (la implementaremos más adelante)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProviderScreen(proveedor: proveedor),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _confirmarEliminarProveedor(proveedor['provider_id']);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Confirmación para eliminar proveedor
  void _confirmarEliminarProveedor(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar'),
          content: Text('¿Estás seguro que deseas eliminar este proveedor?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () async {
                try {
                  await apiService.eliminarProveedor(id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Proveedor eliminado con éxito')),
                  );
                  setState(() {}); // Refresca la lista
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar el proveedor')),
                  );
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

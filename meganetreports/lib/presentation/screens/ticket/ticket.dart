import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import 'dart:io';
import 'dart:typed_data';

class TicketSend extends StatefulWidget {
  final String nombre;
  final String plan;
  final String precio;
  final String telefono;
  final String mesPago;
  final String total;
  final String? descuento;
  final String? descripcion;

  const TicketSend({
    Key? key,
    required this.nombre,
    required this.plan,
    required this.precio,
    required this.telefono,
    required this.mesPago,
    required this.total,
    this.descuento,
    this.descripcion,
  }) : super(key: key);

  @override
  State<TicketSend> createState() => _TicketSendState();
}

class _TicketSendState extends State<TicketSend> {

  //Capturar pantalla
  final controllerT = ScreenshotController();


  String fechaFormateada = '';

  @override
  void initState() {
    super.initState();
    // Inicializa la localización en 'es' (español)
    initializeDateFormatting('es', null).then((_) {
      // Formatea la fecha en español y actualiza el estado
      setState(() {
        fechaFormateada = DateFormat('MMMM d y, HH:mm:ss', 'es').format(DateTime.now().toLocal());
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 26, 26),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 26, 26, 26),
        title: const Text('Ticket de Pago', style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _copyTicketDetails(context), 
            icon: const Icon(Icons.copy), color: Colors.white
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white,),
            onPressed: () async {
              // Implementar la funcionalidad de compartir aquí
              final image = await controllerT.capture();
              if (image == null) return;

              await saveAndShare(image);
            },
          ),
        ],
      ),
      body: Screenshot(
        controller: controllerT,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Comprobante de Pago',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInfoRow('Cliente', widget.nombre),
                    _buildInfoRow('Teléfono', widget.telefono),
                    _buildInfoRow('Plan', widget.plan),
                    _buildInfoRow('Precio', 'Q${widget.precio}'),
                    _buildInfoRow('Mes de Pago', widget.mesPago),
                    _buildInfoRow('Descuento', widget.descuento != null ? '-Q${widget.descuento}' : 'Q0.00'),
                    const Divider(thickness: 2),
                    _buildInfoRow('Total', 'Q${widget.total}', isTotal: true),
                    if (widget.descripcion != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          'Descripción: ${widget.descripcion}',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    const SizedBox(height: 20),
                    Text ('Generado en, Caserío Nueva Jerusalem, San Antonio S, S.M. $fechaFormateada', style: const TextStyle(color: Colors.grey),),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Mega', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                        const Text('Net', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                        SizedBox(width: 10.h),
                        const Icon(Icons.qr_code, size: 35, color: Colors.grey),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 16,
              color: isTotal ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }

  void _copyTicketDetails(BuildContext context) {
    final String ticketDetails = '''
Cliente: ${widget.nombre}
Teléfono: ${widget.telefono}
Plan: ${widget.plan}
Precio: Q${widget.precio}
Mes de Pago: ${widget.mesPago}
${widget.descuento != null ? 'Descuento: - Q${widget.descuento}\n' : '0.00'}
Total: Q${widget.total}
${widget.descripcion != null ? '\nDescripción: ${widget.descripcion}' : ''}
    '''.trim();

    Clipboard.setData(ClipboardData(text: ticketDetails));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Detalles del ticket copiados al portapapeles')),
    );
  }
}

Future<String> saveImage(Uint8List bytes) async {
  await [Permission.storage].request();

  final time = DateTime.now()
      .toIso8601String()
      .replaceAll('.', '_')
      .replaceAll(':', '_');

  final name = 'Screenshot_$time';
  final result =
      await ImageGallerySaver.saveImage(Uint8List.fromList(bytes), name: name);

  return result['filePath'];
}

Future saveAndShare(Uint8List bytes) async {
  final directory = await getTemporaryDirectory();
  final image = File('${directory.path}/image.png');
  image.writeAsBytesSync(bytes);
  await Share.shareFiles([image.path], text: 'Le compartimos su comprobante de pago de su servicio de Internet. *MegaNet*');
}
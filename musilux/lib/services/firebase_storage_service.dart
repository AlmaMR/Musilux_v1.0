import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseStorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Sube una imagen a Firebase Storage y retorna la URL de descarga.
  /// [imageFile] - Archivo seleccionado con image_picker.
  /// [productId] - ID del producto (puede ser un UUID temporal para productos nuevos).
  static Future<String> uploadProductImage(XFile imageFile, String productId) async {
    final file = File(imageFile.path);
    final extension = imageFile.name.split('.').last;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final ref = _storage.ref('productos/$productId/$timestamp.$extension');

    final uploadTask = await ref.putFile(
      file,
      SettableMetadata(contentType: 'image/$extension'),
    );

    return await uploadTask.ref.getDownloadURL();
  }
}

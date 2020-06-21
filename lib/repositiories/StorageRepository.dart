import 'dart:io';

import 'package:kopper/providers/StorageProvider.dart';

// Uploads file images
class StorageRepository{
  StorageProvider storageProvider = StorageProvider();
  Future<String> uploadImage(File file, String path) => storageProvider.uploadImage(file, path);
} 

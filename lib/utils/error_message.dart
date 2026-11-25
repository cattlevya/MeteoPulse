import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Mengubah objek error teknis menjadi pesan yang ramah pengguna.
String friendlyError(Object e) {
  if (e is SocketException ||
      e is TimeoutException ||
      e is http.ClientException) {
    return 'Tidak ada koneksi internet. Coba lagi.';
  }
  if (e is FormatException || e is TypeError) {
    return 'Data tidak valid.';
  }
  return e.toString().replaceFirst('Exception: ', '');
}

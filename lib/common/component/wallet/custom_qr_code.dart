import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CustomQrCode extends StatelessWidget {
  final String data;
  final double size;

  const CustomQrCode({super.key, required this.data, this.size = 300});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: QrImageView(
        data: data,
        size: size,
      ),
    );
  }
}

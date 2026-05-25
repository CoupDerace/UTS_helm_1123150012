import 'package:flutter/material.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan Saya'),
      ),
      body: const Center(
        child: Text('Daftar pesanan akan ditampilkan di sini.'),
      ),
    );
  }
}
Color _statusColor(String status) {
  return switch (status) {
    'pending'    => Colors.orange,
    'processing' => Colors.blue,
    'shipped'    => Colors.purple,
    'delivered'  => Colors.green,
    'cancelled'  => Colors.red,
    _            => Colors.grey,
  };
}

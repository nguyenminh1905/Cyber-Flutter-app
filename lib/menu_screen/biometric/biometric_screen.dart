import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricTest extends StatelessWidget {
  const BiometricTest({super.key});

  Future<void> _authenticate(BuildContext context) async {
    final auth = LocalAuthentication();

    try {
      //Kiểm tra thiết bị có hỗ trợ sinh trắc học không
      final canAuthenticate =
          await auth.canCheckBiometrics || await auth.isDeviceSupported();

      if (!canAuthenticate) {
        if (context.mounted) {
          _showDialog(context, "Thiết bị không hỗ trợ sinh trắc học");
        }
        return;
      }

      // 2. Thực hiện xác thực
      final isAuthenticated = await auth.authenticate(
        localizedReason: 'Xác thực để tiếp tục',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      if (context.mounted) {
        if (isAuthenticated) {
          _showDialog(context, "Xác thực thành công");
        } else {
          _showDialog(context, "Xác thực thất bại");
        }
      }
    } catch (e) {
      _showDialog(context, "Lỗi: $e");
    }
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Kết quả"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Biometric")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _authenticate(context),
          child: const Text("Xác thực"),
        ),
      ),
    );
  }
}

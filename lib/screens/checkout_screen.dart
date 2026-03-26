import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/product.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedMethod = 'Credit';
  bool saveCardData = false;

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Product>('cartBox');
    final items = box.values.toList();
    double total = items.fold(0, (sum, item) => sum + item.total);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Payment data",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Total price",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              "\$${total.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A6CF7),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Payment Method",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildPaymentMethodTab('PayPal', Icons.payment),
                const SizedBox(width: 12),
                _buildPaymentMethodTab('Credit', Icons.credit_card),
                const SizedBox(width: 12),
                _buildPaymentMethodTab('Wallet', Icons.account_balance_wallet),
              ],
            ),
            const SizedBox(height: 32),
            _buildInputField(
              label: "Card number",
              hint: "**** **** **** ****",
              icon: Icons.credit_card,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    label: "Valid until",
                    hint: "Month / Year",
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildInputField(
                    label: "CVV",
                    hint: "***",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInputField(
              label: "Card holder",
              hint: "Your name and surname",
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Save card data for future payments",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Switch(
                  value: saveCardData,
                  onChanged: (value) {
                    setState(() {
                      saveCardData = value;
                    });
                  },
                  activeColor: const Color(0xFF4A6CF7),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A6CF7),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: () => _showSuccessDialog(context, box),
              child: const Text(
                "Proceed to confirm",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTab(String method, IconData icon) {
    bool isSelected = selectedMethod == method;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedMethod = method;
          });
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4A6CF7) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF4A6CF7).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSelected)
                const Icon(Icons.check_circle, color: Colors.white, size: 16),
              if (isSelected) const SizedBox(width: 4),
              Text(
                method,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: icon != null ? Icon(icon, color: Colors.red) : null,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  void _showSuccessDialog(BuildContext context, Box<Product> box) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              SizedBox(height: 10),
              Text("¡Pago Exitoso!"),
            ],
          ),
          content: const Text(
            "Gracias por tu compra. Tu pedido ha sido procesado.",
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                box.clear();
                Navigator.pop(context);
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }
}

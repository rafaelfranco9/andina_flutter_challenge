import 'package:flutter/material.dart';

class AddBeneficiaryActionButton extends StatelessWidget {
  const AddBeneficiaryActionButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onPressed: onPressed,
      label: const Text('Add Beneficiary'),
      icon: const Icon(Icons.add),
    );
  }
}

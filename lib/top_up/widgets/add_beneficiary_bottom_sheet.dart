import 'package:flutter/material.dart';

class AddBeneficiaryBottomSheet extends StatefulWidget {
  const AddBeneficiaryBottomSheet({super.key, required this.onAddBeneficiary});

  final void Function(String nickname, String phoneNumber) onAddBeneficiary;

  @override
  State<AddBeneficiaryBottomSheet> createState() => _AddBeneficiaryBottomSheetState();
}

class _AddBeneficiaryBottomSheetState extends State<AddBeneficiaryBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nicknameController;
  late final TextEditingController _phoneNumberController;

  @override
  void initState() {
    _nicknameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Beneficiary',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nicknameController,
                autocorrect: false,
                enableSuggestions: false,
                maxLength: 20,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a nickname';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Nickname'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneNumberController,
                autocorrect: false,
                enableSuggestions: false,
                maxLength: 20,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onAddBeneficiary(_nicknameController.text, _phoneNumberController.text);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Add Beneficiary'),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

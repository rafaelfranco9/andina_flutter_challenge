import 'package:andina_flutter_challenge/top_up/constants/constants.dart';
import 'package:flutter/material.dart';

class TopUpOptionsBottomSheet extends StatelessWidget {
  const TopUpOptionsBottomSheet({super.key, required this.onTopUpOptionSelected});
  final void Function(int) onTopUpOptionSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Top Up Options',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                onTopUpOptionSelected(kTopUpOptions[index]);
                Navigator.of(context).pop();
              },
              title: Text(
                'AED ${kTopUpOptions[index]}',
                style: const TextStyle(fontSize: 18),
              ),
              tileColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: kTopUpOptions.length,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

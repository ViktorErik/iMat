import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/imat_data_handler.dart';
import 'card_details.dart';
import 'customer_details.dart';

class CheckoutWizard extends StatefulWidget {
  const CheckoutWizard({super.key});

  @override
  State<CheckoutWizard> createState() => _CheckoutWizardState();
}

class _CheckoutWizardState extends State<CheckoutWizard> {
  final _customerKey = GlobalKey<FormState>();
  final _cardKey     = GlobalKey<FormState>();
  int _currentStep   = 0;

  void _next() async {
    if (_currentStep == 0) {
      if (_customerKey.currentState!.validate()) {
        setState(() => _currentStep = 1);
      }
      return;
    }
    if (_currentStep == 1) {
      if (_cardKey.currentState!.validate()) {
        await _placeOrder();
      }
      return;
    }
  }

  Future<void> _placeOrder() async {
    final iMat = context.read<ImatDataHandler>();
    await iMat.placeOrder();
    if (mounted) setState(() => _currentStep = 2);
  }

  @override
  Widget build(BuildContext context) {
    final total = context.watch<ImatDataHandler>().shoppingCartTotal();

    return SafeArea(
      child: Stepper(
        currentStep: _currentStep,
        onStepContinue: _next,
        controlsBuilder: (ctx, details) {
          if (_currentStep == 2) return const SizedBox();
          return ElevatedButton(
            onPressed: details.onStepContinue,
            child: Text(_currentStep == 1 ? 'Betala ${total.toStringAsFixed(2)} kr' : 'Nästa'),
          );
        },
        steps: [
          Step(
            title: const Text('Personuppgifter'),
            isActive: _currentStep >= 0,
            content: CustomerDetails(
              formKey: _customerKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ),
          Step(
            title: const Text('Kortuppgifter'),
            isActive: _currentStep >= 1,
            content: CardDetails(
              formKey: _cardKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ),
          Step(
            title: const Text('Klart!'),
            isActive: _currentStep >= 2,
            state: StepState.complete,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tack för ditt köp på iMat 🎉'),
                const SizedBox(height: 8),
                Text('Leveransdatum: '
                    '${(DateTime.now().add(const Duration(days: 2)))}'),
                const SizedBox(height: 12),
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Done'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
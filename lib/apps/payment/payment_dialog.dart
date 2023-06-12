import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_dentist/modules/patient.dart';
import 'package:my_dentist/our_widgets/loading_dialog.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';
import 'package:flutter/services.dart';
import 'package:my_dentist/our_widgets/settings.dart';

class PaymentDialog extends StatefulWidget {
  final String patientID;
  const PaymentDialog(this.patientID, {super.key});

  @override
  State<PaymentDialog> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentDialog> {
  late final TextEditingController _cardNumberController;
  late final TextEditingController _dateController;
  late final TextEditingController _cvvController;
  late final TextEditingController _amountController;

  late final GlobalKey<FormState> _formKey;
  late final DateFormat _dateFormat;
  late final String _patientID;

  @override
  void initState() {
    _cardNumberController = TextEditingController();
    _dateController = TextEditingController();
    _cvvController = TextEditingController();
    _amountController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _dateFormat = DateFormat('MM/yy');
    _patientID = widget.patientID;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: OurSettings.mainColors[100],
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width * 0.3,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.credit_card,
                    color: OurSettings.mainColors[400],
                  ),
                  const SizedBox(width: 10.0),
                  const Text(
                    'Credit Card Payment',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _amountController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.]+')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  counterText: '',
                ),
                maxLength: 6,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) =>
                    value!.isNotEmpty ? null : "Can Not Charge 0 Dollars",
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  counterText: '',
                ),
                maxLength: 16,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Card Number";
                  } else if (value.length != 16) {
                    return "Must Be 16 Digits";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      onTap: () => _showDatePicker(context),
                      decoration: const InputDecoration(
                        labelText: 'Expiry Date',
                      ),
                      keyboardType: TextInputType.datetime,
                      readOnly: true,
                      validator: (val) =>
                          val!.isNotEmpty ? null : 'Enter Expiry Date',
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        counterText: '',
                      ),
                      maxLength: 3,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "CVV Is Required";
                        } else if (value.length != 3) {
                          return "Must Be 3 Numbers";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  child: const Text('Pay'),
                  onPressed: () {
                    _submit();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      LoadingDialog.showLoadingDialog(context);

      await Future.delayed(const Duration(seconds: 3));
      void dismissDialogAndNavigate() {
        LoadingDialog.hideLoadingDialog(context);
        Navigator.of(context).pop();
        showSuccessDialog(context, msg: 'Payment completed.');
      }

      dismissDialogAndNavigate();
      await Patient.updatePatientPayment(
          _patientID, -double.parse(_amountController.text));
    }
  }

  void _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 20),
      initialDatePickerMode: DatePickerMode.year,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
            ),
          ),
          child: child!,
        );
      },
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (picked != null) {
      String formattedDate = _dateFormat.format(picked);
      _dateController.text = formattedDate;
    }
  }
}

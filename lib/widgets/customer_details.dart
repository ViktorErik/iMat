import 'package:api_test/model/imat/customer.dart';
import 'package:api_test/model/imat_data_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Simple widget to edit card information.
// It's probably better to use Form
class CustomerDetails extends StatefulWidget {
  const CustomerDetails({super.key, this.formKey, this.autovalidateMode});

  final GlobalKey<FormState>? formKey;
  final AutovalidateMode? autovalidateMode;

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _mobileNumberController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _postCodeController;
  late final TextEditingController _postAddressController;
  late final ImatDataHandler _imatDataHandler;

  @override
  void initState() {
    super.initState();

    _imatDataHandler = Provider.of<ImatDataHandler>(context, listen: false);
    Customer customer = _imatDataHandler.getCustomer();

    _firstNameController = TextEditingController(text: customer.firstName);
    _lastNameController = TextEditingController(text: customer.lastName);
    _mobileNumberController = TextEditingController(
      text: customer.mobilePhoneNumber,
    );
    _emailController = TextEditingController(text: customer.email);
    _addressController = TextEditingController(text: customer.address);
    _postCodeController = TextEditingController(text: customer.postCode);
    _postAddressController = TextEditingController(text: customer.postAddress);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidateMode: widget.autovalidateMode,
      child: Column(
        children: [
          TextFormField(
            controller: _firstNameController,
            decoration: InputDecoration(labelText: 'Förnamn'),
          ),
          TextFormField(
            controller: _lastNameController,
            decoration: InputDecoration(labelText: 'Efternamn'),
          ),
          TextFormField(
            controller: _mobileNumberController,
            decoration: InputDecoration(labelText: 'Mobilnummer'),
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'E-post'),
          ),
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(labelText: 'Adress'),
          ),
          TextFormField(
            controller: _postCodeController,
            decoration: InputDecoration(labelText: 'Postnummer'),
          ),
          TextFormField(
            controller: _postAddressController,
            decoration: InputDecoration(labelText: 'Ort'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: TextStyle(fontSize: 18),       
              ),
              onPressed: _saveCustomer, child: Text('Spara')),
            ],
          ),
        ],
      ),
    );
  }

  _saveCustomer() {
    //var iMat = Provider.of<ImatDataHandler>(context, listen: false);
    Customer customer = _imatDataHandler.getCustomer();

    customer.firstName = _firstNameController.text;
    customer.lastName = _lastNameController.text;
    customer.mobilePhoneNumber = _mobileNumberController.text;
    customer.email = _emailController.text;
    customer.address = _addressController.text;
    customer.postCode = _postCodeController.text;
    customer.postAddress = _postAddressController.text;

    // This is needed to trigger updates to the server
    _imatDataHandler.setCustomer(customer);

    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Leverans och kontaktuppgifter sparade'),
      duration: Duration(seconds: 3),
    )
    );
  }
}

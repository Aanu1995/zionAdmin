import 'package:flutter/material.dart';
import 'package:zion/user_inteface/components/empty_space.dart';
import 'package:zion/user_inteface/utils/validator.dart';

class EditPhone extends StatefulWidget {
  final String phone;
  final void Function(String) onChangedPhone;
  EditPhone({this.phone, this.onChangedPhone});
  @override
  _EditPhoneState createState() => _EditPhoneState();
}

class _EditPhoneState extends State<EditPhone> {
  TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.phone);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Enter your phone number',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          EmptySpace(),
          TextFormField(
            controller: _controller,
            keyboardType: TextInputType.phone,
            autofocus: true,
            validator: Validators.validatePhone(),
            onChanged: widget.onChangedPhone,
          ),
          EmptySpace(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('CANCEL'),
              ),
              FlatButton(
                child: Text('SAVE'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Navigator.pop(context);
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

// this function is called to edit name
Future<String> editPhone(BuildContext context, String phone) async {
  String myPhone;
  await showModalBottomSheet(
    context: context,
    builder: (context) {
      return SingleChildScrollView(
        child: Container(
          margin:
              EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0, bottom: 16.0),
          width: double.maxFinite,
          child: EditPhone(
            phone: phone,
            onChangedPhone: (value) {
              if (Validators.validatePhone2(value) == null) {
                myPhone = value.trim().toString();
                print('hello');
              }
            },
          ),
        ),
      );
    },
  );
  return myPhone;
}

class EditAddress extends StatefulWidget {
  final String address;
  final void Function(String) onChangedAddress;
  EditAddress({this.address = "", this.onChangedAddress});
  @override
  _EditAddressState createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  TextEditingController _controller;
  String state;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.address);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Enter your Addess (include your State)',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          EmptySpace(),
          TextFormField(
            controller: _controller,
            autofocus: true,
            validator: Validators.validateAddress(),
            onChanged: widget.onChangedAddress,
          ),
          EmptySpace(multiple: 2.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('CANCEL'),
              ),
              FlatButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Navigator.pop(context);
                  }
                },
                child: Text('SAVE'),
              )
            ],
          )
        ],
      ),
    );
  }
}

// this function is called to edit name
Future<String> editAddress(BuildContext context, String address) async {
  String myAddress;
  await showModalBottomSheet(
    context: context,
    builder: (context) {
      return SingleChildScrollView(
        child: Container(
          margin:
              EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0, bottom: 16.0),
          width: double.maxFinite,
          child: EditAddress(
            address: address,
            onChangedAddress: (value) {
              if (Validators.validateAddress2(value) == null) {
                myAddress = value.trim().toString();
              }
            },
          ),
        ),
      );
    },
  );
  return myAddress;
}

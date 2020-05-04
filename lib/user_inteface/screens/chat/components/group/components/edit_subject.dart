import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/service/group_chat_service.dart';
import 'package:zion/user_inteface/components/custom_dialogs.dart';

class EditSubject extends StatefulWidget {
  final Group group;
  const EditSubject({this.group});
  @override
  _EditSubjectState createState() => _EditSubjectState();
}

class _EditSubjectState extends State<EditSubject> {
  TextEditingController _controller;
  bool isTapped = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.group.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Enter new subject"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 30.0),
              child: TextField(
                controller: _controller,
                autofocus: true,
                maxLength: 25,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                ),
                maxLengthEnforced: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 5.0),
                  isDense: true,
                  hintText: 'subject...',
                ),
              ),
            ),
          ),
          Divider(height: 0.0),
          SizedBox(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
                VerticalDivider(),
                FlatButton(
                  child: Text('OK'),
                  onPressed: () => _onChangeSubject(
                    _controller.text,
                    widget.group.name,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _onChangeSubject(String newSubject, final oldSubject) async {
    if (oldSubject != newSubject && newSubject.length > 4) {
      CustomDialogs.showProgressDialog(context, text: 'Updating group subject');
      bool connection = await DataConnectionChecker().hasConnection;
      if (connection) {
        await GroupChatService.changeGroupSubject(
            context: context, groupId: widget.group.id, subject: newSubject);
        CustomDialogs.closeProgressDialog(context);
      } else {
        CustomDialogs.closeProgressDialog(context);
        Fluttertoast.showToast(
          msg: "No internet connection",
          gravity: ToastGravity.CENTER,
        );
      }
    } else {
      if (newSubject.length < 5) {
        if (newSubject.isEmpty) {
          Fluttertoast.showToast(
            msg: "subject must be greater than 4 char",
            gravity: ToastGravity.CENTER,
          );
        } else {
          Fluttertoast.showToast(
            msg: "subject must not be empty",
            gravity: ToastGravity.CENTER,
          );
        }
      }
    }
    Navigator.pop(context);
    return;
  }
}

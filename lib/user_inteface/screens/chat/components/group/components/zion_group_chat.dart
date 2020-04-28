import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zion/model/chat.dart';
import 'package:zion/service/chat_service.dart';
import 'package:zion/user_inteface/screens/chat/components/full_image.dart';
import 'package:zion/user_inteface/screens/chat/components/zionchat/zion.dart';
import 'package:zion/user_inteface/screens/chat/components/image_pick_preview_page.dart';

class ZionGroupChat extends StatefulWidget {
  final chatKey;
  final Group group;
  List<ChatMessage> messages;
  final ChatUser user;

  DocumentSnapshot lastDocumentSnapshot;

  ZionGroupChat(
      {this.chatKey,
      this.group,
      this.messages,
      this.user,
      this.lastDocumentSnapshot});

  @override
  _ZionGroupChatState createState() => _ZionGroupChatState();
}

class _ZionGroupChatState extends State<ZionGroupChat> {
  List<ChatMessage> messages = [];
  //checks if the loadmore button as been clicked
  // displays loading indicator if true
  bool isLoadingMore = false;
  List<ChatMessage> falseMessages = [];
  final focusNode = FocusNode();

  KeyboardVisibilityNotification _keyboard = KeyboardVisibilityNotification();
  int id;

  @override
  void initState() {
    super.initState();

    // checks if user is typing
    // send notification to the server if typing
    // and stop typing
    id = _keyboard.addNewListener(
      onChange: (bool visible) async {
        bool connect = await DataConnectionChecker().hasConnection;
        if (connect) {
          if (visible) {
            ChatServcice.isTyping(
              widget.group.id,
              username: widget.user.name,
            );
          } else {
            ChatServcice.isTyping(widget.group.id);
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _keyboard.removeListener(id);
    _keyboard.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    messages = [...falseMessages, ...widget.messages];
    // empty the false messages
    falseMessages.clear();
    return ZionMessageChat(
      key: widget.chatKey,
      onSend: onSend,
      user: widget.user,
      focusNode: focusNode,
      inputDecoration: InputDecoration.collapsed(hintText: "Type a message"),
      timeFormat: DateFormat('h:mm a'),
      messages: messages,
      inputMaxLines: 6,
      alwaysShowSend: true,
      messageImageBuilder: (image, file) {
        return image != null
            ? Hero(
                tag: image,
                child: Material(
                  child: InkWell(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: CachedNetworkImage(
                        imageUrl: image,
                        fit: BoxFit.fitWidth,
                        placeholder: (context, value) {
                          return Shimmer.fromColors(
                            child: Container(
                              height: double.maxFinite,
                              width: double.maxFinite,
                            ),
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.grey[100],
                          );
                        },
                      ),
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            FullImage(imageUrl: image, hero: image),
                      ),
                    ),
                  ),
                ),
              )
            : Image.file(
                file,
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.8,
                fit: BoxFit.fitWidth,
              );
      },
      shouldShowLoadEarlier: true,
      isLoadingMore: isLoadingMore,
      onLoadEarlier: () => loadMore(),
      leading: IconButton(
        icon: Icon(Icons.photo),
        onPressed: onSendImage,
      ),
    );
  }

// send chat messages (text)
  void onSend(final message) {
    ChatServcice.sendMessage(message: message, chatId: widget.group.id);
  }

// send chat images to the server
  void onSendImage() async {
    // send images picked during chat to the server
    File result = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    if (result != null) {
      // navigate to screen to preview image and add a caption to the image
      final text = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ImagePickPreviewPage(image: result),
      ));
      if (text != null) {
        ChatMessage message = ChatMessage(
          text: text,
          messageStatus: -1,
          user: widget.user,
          imageFile: result,
        );
        falseMessages.add(message);
        setState(() {});
        await ChatServcice.sendImage(
          file: result,
          text: text,
          user: widget.user,
          chatId: widget.group.id,
          status: 0,
        );
      }
    }
  }

//loads more images from the server
  void loadMore() async {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      isLoadingMore = true;
      setState(() {});
    });
    List<DocumentSnapshot> result = await ChatServcice.loadMoreMessages(
        widget.group.id, widget.lastDocumentSnapshot);
    if (result.isNotEmpty) {
      widget.lastDocumentSnapshot = result[result.length - 1];
      final newMessages =
          result.map((i) => ChatMessage.fromJson(i.data)).toList();
      widget.messages.addAll(newMessages);
    }
    SchedulerBinding.instance.addPostFrameCallback((_) {
      isLoadingMore = false;
      setState(() {});
    });
  }
}

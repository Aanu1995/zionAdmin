part of zion_chat;

class ChatInputToolbar extends StatelessWidget {
  final TextEditingController controller;
  final TextStyle inputTextStyle;
  final Widget leading;
  final ChatUser user;
  final Function(ChatMessage) onSend;
  final String text;
  final Function(String) onTextChange;
  final String Function() messageIdGenerator;
  final Widget Function(Function) sendButtonBuilder;
  final Widget Function() inputFooterBuilder;
  final bool showInputCursor;
  final double inputCursorWidth;
  final Color inputCursorColor;
  final FocusNode focusNode;
  final EdgeInsets inputToolbarPadding;
  final EdgeInsets inputToolbarMargin;

  ChatInputToolbar({
    Key key,
    this.focusNode,
    this.text,
    this.onTextChange,
    this.controller,
    this.leading,
    this.inputTextStyle,
    this.showInputCursor = true,
    this.inputCursorWidth = 2.0,
    this.inputCursorColor,
    this.onSend,
    @required this.user,
    this.messageIdGenerator,
    this.inputFooterBuilder,
    this.sendButtonBuilder,
    this.inputToolbarPadding = const EdgeInsets.all(0.0),
    this.inputToolbarMargin = const EdgeInsets.all(0.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatMessage message = ChatMessage(
      text: text,
      user: user,
      messageIdGenerator: messageIdGenerator,
      createdAt: DateTime.now(),
    );

    return Container(
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextField(
                  focusNode: focusNode,
                  onChanged: (value) {
                    onTextChange(value);
                  },
                  buildCounter: (
                    BuildContext context, {
                    int currentLength,
                    int maxLength,
                    bool isFocused,
                  }) =>
                      null,
                  decoration: InputDecoration(
                    prefixIcon: leading,
                    fillColor: Colors.white70,
                    filled: true,
                    contentPadding: EdgeInsets.only(
                        left: 10.0, top: 8.0, bottom: 8.0, right: 10.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    hintText: "Type a message",
                  ),
                  controller: controller,
                  style: inputTextStyle,
                  minLines: 1,
                  maxLines: 6,
                  showCursor: showInputCursor,
                  cursorColor: inputCursorColor,
                  cursorWidth: inputCursorWidth,
                ),
              ),
              SizedBox(width: 8.0),
              InkWell(
                child: CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 26.0,
                  ),
                ),
                onTap: text.length != 0
                    ? () async {
                        if (text.length != 0) {
                          await onSend(message);
                          controller.text = "";
                          onTextChange("");
                        }
                      }
                    : null,
              )
            ],
          ),
          if (inputFooterBuilder != null) inputFooterBuilder()
        ],
      ),
    );
  }
}

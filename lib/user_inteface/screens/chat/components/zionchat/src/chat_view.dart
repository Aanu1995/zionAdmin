part of zion_chat;

/// A complete chat UI which is inspired by [react-native-gifted-chat]
/// Highly customizable and helps developing chat UI faster
class ZionMessageChat extends StatefulWidget {
  /// Flex value for the messeage container defaults to 1
  /// Made so that the message container takes as much as possible
  /// if no height or width is passed explicity
  final int messageContainerFlex;

  /// Height for the Dash chat Widget
  final double height;

  // Width for the Dash chat Widget
  final double width;

  /// List of messages to display in the chat container
  /// Takes a [List] of [ChatMessage]
  final List<ChatMessage> messages;

  /// If provided, this text editing controller will be used for
  /// the text input.
  final TextEditingController textController;

  /// If provided, this focus node will be used for the text input.
  final FocusNode focusNode;

  /// Use to change the direction of the text ltr is used for
  /// launguages that start from left like English &
  /// rtl is used for languages like Arabic
  ///
  /// Defaults to `TextDirection.ltr`
  final TextDirection inputTextDirection;

  /// If provided will stop using the default controller
  /// i.e [TextEditingController] and will use this to update the
  /// text input field.
  final String text;

  /// If the text parameter is passed then onTextChange must also
  /// be passed.
  final Function(String) onTextChange;

  /// Used to provide input decoration to the text as default only
  /// to the input placeholder for the chat input
  /// "Add Message here...".
  final InputDecoration inputDecoration;

  ///Configures how the platform keyboard will select an uppercase or lowercase keyboard.
  ///Only supports text keyboards, other keyboard types will ignore this configuration. Capitalization is locale-aware.
  ///Defaults to [TextCapitalization.none]. Must not be null.
  final TextCapitalization textCapitalization;

  /// Usually new message added by the user gets [Uuid] String
  /// Can be override by proving this parameter
  final String Function() messageIdGenerator;

  /// The current user object [ChatUser].
  final ChatUser user;

  /// To function where you can make api calls and play
  /// with the [ChatMessage] obeject before make calls.
  final Function(ChatMessage) onSend;

  /// Should the send button be always active it defaults to false
  /// Usually it will only become active if some text is entered.
  final bool alwaysShowSend;

  /// [DateFormat] object for formatting date to show in [MessageListView]
  /// defaults to `HH:mm:ss`.
  final DateFormat dateFormat;

  /// [DateFormat] object for formatting time to show in [MessageContainer]
  /// defaults to `yyyy-MM-dd`.
  final DateFormat timeFormat;

  /// [onLongPressMessage] function takea a function with this structure
  /// [Function(ChatMessage)] will trigger when the message
  /// is long pressed.
  final Function(ChatMessage) onLongPressMessage;

  /// messageImageBuilder will override the the default Image.
  final Widget Function(String url, File file) messageImageBuilder;

  /// A Widget that will be shown below the [MessageListView] like you can
  /// show a "tying..." at the end.
  final Widget Function() chatFooterBuilder;

  /// Main input length of the input text box defaulst to no limit.
  final int maxInputLength;

  /// Used to parse text to make it linkified text uses
  /// [flutter_parsed_text](https://pub.dev/packages/flutter_parsed_text)
  /// takes a list of [MatchText] in order to parse Email, phone, links
  /// and can also add custom pattersn using regex
  final List<MatchText> parsePatterns;

  /// Provides a custom style to the message container
  /// takes [BoxDecoration]
  final BoxDecoration messageContainerDecoration;

  /// [List] of [Widget] to show before the [TextField].
  final Widget leading;

  /// [List] of [Widget] to show after the [TextField].will remove the
  /// send button and will have to implement that yourself.

  /// sendButtonBuilder will override the the default [IconButton].
  final Widget Function(Function) sendButtonBuilder;

  /// Style for the [TextField].
  final TextStyle inputTextStyle;

  /// [TextField] container style.
  final BoxDecoration inputContainerStyle;

  /// Max length of the input lines default to 1.
  final int inputMaxLines;

  /// Should the input cursor be shown defaults to true.
  final bool showInputCursor;

  /// Width of the text input defaults to 2.0.
  final double inputCursorWidth;

  /// Color of the input cursor defaults to theme.
  final Color inputCursorColor;

  /// ScrollController for the [MessageListView] will use the default
  /// scrollcontroller in the Widget.
  final ScrollController scrollController;

  /// A Widget that will be shown below the [ChatInputToolbar] like you can
  /// show a list of buttons like file image just like in Slack app.
  final Widget Function() inputFooterBuilder;

  /// Should the LoadEarlier Floating widget be shown or use
  /// load as you scroll scheme whcih will call the [onLoadEarlier]
  /// function as default it is set to this scheme which is false.
  /// false - load as you scroll scheme
  /// true - shows a loadEarlier Widget
  final bool shouldShowLoadEarlier;

  /// Override the default behaviour of the onScrollToBottom Widget
  final bool isLoadingMore;

  /// Override the default behaviour of the onLoadEarleir Widget
  /// or used as a callback when the listView reaches the top
  final Function onLoadEarlier;

  /// Padding for the default input toolbar
  /// by default it padding is set 0.0
  final EdgeInsets inputToolbarPadding;

  /// Margin for the default input toolbar
  /// by default it padding is set 0.0
  final EdgeInsets inputToolbarMargin;
  final Color fromColor;

  ZionMessageChat({
    Key key,
    this.inputTextDirection = TextDirection.ltr,
    this.inputToolbarMargin = const EdgeInsets.all(0.0),
    this.inputToolbarPadding = const EdgeInsets.all(0.0),
    this.shouldShowLoadEarlier = false,
    this.isLoadingMore,
    this.onLoadEarlier,
    this.scrollController,
    this.inputCursorColor,
    this.fromColor,
    this.inputCursorWidth = 2.0,
    this.showInputCursor = true,
    this.inputMaxLines = 1,
    this.inputContainerStyle,
    this.inputTextStyle,
    this.leading,
    this.messageContainerDecoration,
    this.messageContainerFlex = 1,
    this.height,
    this.width,
    @required this.messages,
    this.onTextChange,
    this.text,
    this.textController,
    this.focusNode,
    this.inputDecoration,
    this.textCapitalization = TextCapitalization.none,
    this.alwaysShowSend = false,
    this.messageIdGenerator,
    this.dateFormat,
    this.timeFormat,
    @required this.user,
    @required this.onSend,
    this.onLongPressMessage,
    this.maxInputLength,
    this.parsePatterns = const <MatchText>[],
    this.chatFooterBuilder,
    this.inputFooterBuilder,
    this.sendButtonBuilder,
    this.messageImageBuilder,
  }) : super(key: key);

  String getVal() {
    return text;
  }

  @override
  ZionMessageChatState createState() => ZionMessageChatState();
}

class ZionMessageChatState extends State<ZionMessageChat> {
  FocusNode inputFocusNode;
  TextEditingController textController;
  ScrollController scrollController;
  String _text = "";
  bool visible = false;

  GlobalKey inputKey = GlobalKey();
  double height = 48.0;
  bool showLoadMore = false;
  String get messageInput => _text;

  void onTextChange(String text) {
    setState(() {
      this._text = text;
    });
  }

  void changeDefaultLoadMore(bool value) {
    setState(() {
      showLoadMore = value;
    });
  }

  @override
  void initState() {
    scrollController = widget.scrollController ?? ScrollController();
    textController = widget.textController ?? TextEditingController();
    inputFocusNode = widget.focusNode ?? FocusNode();
    WidgetsBinding.instance.addPostFrameCallback(widgetBuilt);
    super.initState();
  }

  void widgetBuilt(Duration d) {
    scrollController.addListener(() {
      if (widget.shouldShowLoadEarlier) {
        if (scrollController.offset >=
                scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange) {
          setState(() {
            showLoadMore = true;
          });
        } else {
          setState(() {
            showLoadMore = false;
          });
        }
      } else {
        if (scrollController.offset >=
                scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange) {
          widget.onLoadEarlier();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height != null
          ? widget.height
          : MediaQuery.of(context).size.height - 80.0,
      width: widget.width != null
          ? widget.width
          : MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: MessageListView(
              shouldShowLoadEarlier: widget.shouldShowLoadEarlier,
              isLoadingMore: widget.isLoadingMore,
              onLoadEarlier: widget.onLoadEarlier,
              fromColor: widget.fromColor,
              defaultLoadCallback: changeDefaultLoadMore,
              scrollController: widget.scrollController != null
                  ? widget.scrollController
                  : scrollController,
              user: widget.user,
              messages: widget.messages,
              dateFormat: widget.dateFormat,
              timeFormat: widget.timeFormat,
              onLongPressMessage: widget.onLongPressMessage,
              messageImageBuilder: widget.messageImageBuilder,
              parsePatterns: widget.parsePatterns,
              visible: visible,
              showLoadMore: showLoadMore,
            ),
          ),
          if (widget.messages.length != 0 &&
              widget.messages[widget.messages.length - 1].user.uid !=
                  widget.user.uid)
            if (widget.chatFooterBuilder != null) widget.chatFooterBuilder(),
          SizedBox(height: 16.0),
          ChatInputToolbar(
            key: inputKey,
            inputToolbarPadding: widget.inputToolbarPadding,
            inputToolbarMargin: widget.inputToolbarMargin,
            controller: textController,
            onSend: widget.onSend,
            user: widget.user,
            messageIdGenerator: widget.messageIdGenerator,
            sendButtonBuilder: widget.sendButtonBuilder,
            text: widget.text != null ? widget.text : _text,
            onTextChange: widget.onTextChange != null
                ? widget.onTextChange
                : onTextChange,
            leading: widget.leading,
            inputTextStyle: widget.inputTextStyle,
            inputFooterBuilder: widget.inputFooterBuilder,
            inputCursorColor: widget.inputCursorColor,
            inputCursorWidth: widget.inputCursorWidth,
            showInputCursor: widget.showInputCursor,
            focusNode: inputFocusNode,
          )
        ],
      ),
    );
  }
}

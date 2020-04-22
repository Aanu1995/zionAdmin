part of zion_chat;

/// MessageContainer is just a wrapper around [Text], [Image]
/// component to present the message
class MessageContainer extends StatelessWidget {
  /// Message Object that will be rendered
  /// Takes a [ChatMessage] object
  final ChatMessage message;

  /// [DateFormat] object to render the date in desired
  /// format, if no format is provided it use
  /// the default `HH:mm:ss`
  final DateFormat timeFormat;

  final Widget Function(String url, File file) messageImageBuilder;

  /// Used to parse text to make it linkified text uses
  /// [flutter_parsed_text](https://pub.dev/packages/flutter_parsed_text)
  /// takes a list of [MatchText] in order to parse Email, phone, links
  /// and can also add custom pattersn using regex
  final List<MatchText> parsePatterns;

  /// A flag which is used for assiging styles
  final bool isUser;
  final Color fromColor;

  const MessageContainer({
    @required this.message,
    @required this.timeFormat,
    @required this.fromColor,
    this.messageImageBuilder,
    this.parsePatterns = const <MatchText>[],
    this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 1,
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 12),
        child: ClipRRect(
          borderRadius: isUser
              ? BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                )
              : BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
          child: Card(
            margin: EdgeInsets.all(0.0),
            child: Container(
              color: isUser
                  ? Theme.of(context).accentColor.withOpacity(0.3)
                  : Colors.grey[300],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  if (message.user.name != null && !isUser)
                    Container(
                      margin:
                          EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0),
                      child: Text(
                        message.user.name,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: fromColor,
                        ),
                      ),
                    ),
                  if (message.image != null || message.imageFile != null)
                    if (messageImageBuilder != null)
                      Container(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: messageImageBuilder(
                            message.image, message.imageFile),
                      ),
                  if (message.text.isNotEmpty && message.text != null)
                    Padding(
                      padding: EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 8.0, bottom: 5.0),
                      child: ParsedText(
                        parse: parsePatterns,
                        text: message.text,
                        style: TextStyle(
                          fontSize: 15.5,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  isUser
                      ? FittedBox(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 8.0, bottom: 4.0, right: 8.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  timeFormat != null
                                      ? timeFormat.format(message.createdAt)
                                      : DateFormat('h:mm a')
                                          .format(message.createdAt),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(width: 4.0),
                                if (message.messageStatus == -1)
                                  statusIcon(icon: Icons.query_builder),
                                if (message.messageStatus == 0)
                                  statusIcon(icon: Icons.done),
                                if (message.messageStatus == 1)
                                  statusIcon(icon: Icons.done_all),
                                if (message.messageStatus == 2)
                                  statusIcon(
                                    icon: Icons.done_all,
                                    color: Colors.blue,
                                  ),
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(
                              left: 8.0, bottom: 4.0, right: 8.0),
                          child: Text(
                            timeFormat != null
                                ? timeFormat.format(message.createdAt)
                                : DateFormat('h:mm a')
                                    .format(message.createdAt),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget statusIcon({IconData icon, Color color}) {
    return Icon(
      icon,
      size: 20.0,
      color: color ?? Colors.black38,
    );
  }
}

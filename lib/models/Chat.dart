class Chat {
  String username;
  int chatId;
  Chat(this.username, this.chatId);
  @override
  String toString() => '{ username= $username, chatId = $chatId}';
}

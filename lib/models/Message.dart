import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kopper/config/Constants.dart';
import 'package:kopper/utils/SharedObjects.dart';

abstract class Message {
  int timeStamp;
  String senderUsername;
  String receiverUsername;
  bool isSelf = true;

  Message(this.timeStamp, this.senderUsername, this.receiverUsername);

  bool operator ==(covariant Message rhs) {
    return timeStamp == rhs.timeStamp;
  }

  factory Message.fromServerJson(Map<String, dynamic> json) {
    return TextMessage.fromServerJson(json);
  }

  factory Message.fromRabbitJson(Map<String, dynamic> json) {
    return TextMessage.fromRabbitJson(json);
  }

  // factory Message.fromFireStore(DocumentSnapshot doc) {
  //   final int type = doc.data['type'];
  //   Message message;
  //   switch (type) {
  //     case 0:
  //       message = TextMessage.fromFirestore(doc);
  //       break;
  //     case 1:
  //       message = ImageMessage.fromFirestore(doc);
  //       break;
  //     case 2:
  //       message = VideoMessage.fromFirestore(doc);
  //       break;
  //     case 3:
  //       message = FileMessage.fromFirestore(doc);
  //   }
  //   message.isSelf = SharedObjects.prefs.getString(Constants.sessionUsername) ==
  //       message.senderUsername;
  //   return message;
  // }

  Map<String, dynamic> toMap();
}

class TextMessage extends Message {
  String text;

  TextMessage(this.text, timeStamp, senderUsername, receiverUsername)
      : super(timeStamp, senderUsername, receiverUsername);

  factory TextMessage.fromServerJson(Map<String, dynamic> json) {
    return TextMessage(
        (json['content'] ?? "") as String,
        DateTime.parse(json['timeStamp'] as String).millisecondsSinceEpoch,
        json['senderUsername'] as String,
        json['receiverUsername'] as String);
  }

  factory TextMessage.fromRabbitJson(Map<String, dynamic> json) {
    return TextMessage(
        (json['Content'] ?? "") as String,
        DateTime.now().millisecondsSinceEpoch,
        json['SenderUsername'] as String,
        json['ReceiverUsername'] as String);
  }

  @override
  bool operator ==(covariant TextMessage rhs) {
    return timeStamp == rhs.timeStamp && text == rhs.text;
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();

    map['SenderUsername'] = senderUsername;
    map['ReceiverUsername'] = receiverUsername;
    map['Content'] = text;

    return map;
  }
}

// class ImageMessage extends Message {
//   String imageUrl;

//   ImageMessage(this.imageUrl, timeStamp, senderName, senderUsername)
//       : super(timeStamp, senderName, senderUsername);

//   factory ImageMessage.fromFirestore(DocumentSnapshot doc) {
//     Map data = doc.data;
//     return ImageMessage(data['imageUrl'], data['timeStamp'], data['senderName'],
//         data['senderUsername']);
//   }

//   @override
//   Map<String, dynamic> toMap() {
//     Map<String, dynamic> map = Map();
//     // map['imageUrl'] = imageUrl;
//     // map['timeStamp'] = timeStamp;
//     map['SenderName'] = senderName;
//     map['SenderUsername'] = senderUsername;
//     // map['type'] = 1;
//     return map;
//   }
// }

// class VideoMessage extends Message {
//   String videoUrl;

//   VideoMessage(this.videoUrl, timeStamp, senderName, senderUsername)
//       : super(timeStamp, senderName, senderUsername);

//   factory VideoMessage.fromFirestore(DocumentSnapshot doc) {
//     Map data = doc.data;
//     return VideoMessage(data['videoUrl'], data['timeStamp'], data['senderName'],
//         data['senderUsername']);
//   }

//   @override
//   Map<String, dynamic> toMap() {
//     Map<String, dynamic> map = Map();
//     map['videoUrl'] = videoUrl;
//     map['timeStamp'] = timeStamp;
//     map['senderName'] = senderName;
//     map['senderUsername'] = senderUsername;
//     map['type'] = 2;
//     return map;
//   }
// }

// class FileMessage extends Message {
//   String fileUrl;

//   FileMessage(this.fileUrl, timeStamp, senderName, senderUsername)
//       : super(timeStamp, senderName, senderUsername);

//   factory FileMessage.fromFirestore(DocumentSnapshot doc) {
//     Map data = doc.data;
//     return FileMessage(data['fileUrl'], data['timeStamp'], data['senderName'],
//         data['senderUsername']);
//   }

//   @override
//   Map<String, dynamic> toMap() {
//     Map<String, dynamic> map = Map();
//     map['fileUrl'] = fileUrl;
//     map['timeStamp'] = timeStamp;
//     map['senderName'] = senderName;
//     map['senderUsername'] = senderUsername;
//     map['type'] = 3;
//     return map;
//   }
// }

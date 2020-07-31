import 'package:firebase_storage/firebase_storage.dart';

class Attachment {
  String downloadurl;
  String filename;
  String filesize;
  StorageReference ref;
  Attachment({this.downloadurl, this.filename, this.filesize, this.ref});

  toJson() {
    return {
      "downloadurl": downloadurl,
      "filename": filename,
      'filesize': filesize,
      //'ref': ref.toString(),
    };
  }

  Attachment.fromJson(Map<String, dynamic> json) {
    downloadurl = json['downloadurl'];
    filename = json["filename"];
    filesize = json['filesize'];
  }
}

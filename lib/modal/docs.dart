class DocumentsModel {
  String? id;
  String? email;
  String? fileName;
  String? fileType;
  int? fileSize;
  String? blobUrl;

  DocumentsModel(
      {this.id,
        this.email,
        this.fileName,
        this.fileType,
        this.fileSize,
        this.blobUrl});

  DocumentsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    fileName = json['fileName'];
    fileType = json['fileType'];
    fileSize = json['fileSize'];
    blobUrl = json['blobUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['fileName'] = this.fileName;
    data['fileType'] = this.fileType;
    data['fileSize'] = this.fileSize;
    data['blobUrl'] = this.blobUrl;
    return data;
  }
}
class AssetsModel {
  String? id;
  String? email;
  String? assetName;
  String? assetsCode;
  String? serialNo;
  String? isWorking;
  String? type;
  String? issuedDate;
  String? note;

  AssetsModel(
      {this.id,
        this.email,
        this.assetName,
        this.assetsCode,
        this.serialNo,
        this.isWorking,
        this.type,
        this.issuedDate,
        this.note});

  AssetsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    assetName = json['assetName'];
    assetsCode = json['assetsCode'];
    serialNo = json['serialNo'];
    isWorking = json['isWorking'];
    type = json['type'];
    issuedDate = json['issuedDate'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['assetName'] = this.assetName;
    data['assetsCode'] = this.assetsCode;
    data['serialNo'] = this.serialNo;
    data['isWorking'] = this.isWorking;
    data['type'] = this.type;
    data['issuedDate'] = this.issuedDate;
    data['note'] = this.note;
    return data;
  }
}
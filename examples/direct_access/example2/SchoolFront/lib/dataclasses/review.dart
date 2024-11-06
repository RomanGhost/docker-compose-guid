class Review{
  final int rate;
  final String text;
  String source="";
  String userData="Аноним";
  bool showUserData;

  Review({
    required this.rate,
    required this.text,
    this.source='',
    this.userData='',
    this.showUserData=false
  });

  Review.undefined():
      rate=0, text='', userData='', source='', showUserData=true;

  Map<String, dynamic> getJson(){
    return {
      "rate": this.rate,
      "text": this.text,
      "source": this.source,
      "showUserData": this.showUserData
    };
  }
}
abstract class BaseModel {
  BaseModel copyWith();
  Map<String, dynamic> toJson();
  int getId();
  List<String> getDisplayData();
}

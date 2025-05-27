import 'package:objectbox/objectbox.dart';

@Entity()
class MySubscriptionDbModel {
  @Id()
  int id;

  String title;
  List<int> subscriptions;

  MySubscriptionDbModel({
    this.id = 0,
    required this.title,
    required this.subscriptions,
  });

  @override
  String toString() {
    return 'MySubscriptionDbModel{id: $id, title: $title, subscriptions: $subscriptions}';
  }
}

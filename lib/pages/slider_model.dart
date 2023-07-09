import 'package:equatable/equatable.dart';

class Catagory extends Equatable {
  final String name;
  final String imageUrl;

  const Catagory({required this.name, required this.imageUrl});

  @override
  List<Object?> get props => [name, imageUrl];
  static List<Catagory> Catagories = [
    const Catagory(
      name: 'Cleaning',
      imageUrl: 'assets/images/sliderpics/clean.jpeg',
    ),
    const Catagory(
      name: 'Lets Ironing',
      imageUrl: 'assets/images/sliderpics/iron1.jpeg',
    ),
    const Catagory(
      name: 'Ready Your Cloth',
      imageUrl: 'assets/images/sliderpics/ready.jpeg',
    ),
    const Catagory(
      name: 'Lets Wash Your Cloth',
      imageUrl: 'assets/images/sliderpics/washing.jpeg',
    ),
  ];
}

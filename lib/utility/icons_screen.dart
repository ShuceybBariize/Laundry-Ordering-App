import '../exports.dart';

// ignore: camel_case_types
class Back_Screen extends StatelessWidget {
  final String? screenname;
  final Function()? popback;
  final Function()? popmenu;
  const Back_Screen({super.key, this.popmenu, this.screenname, this.popback});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  strokeAlign: 0.8,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(10)),
            child: IconButton(
              onPressed: popback,
              icon: const Icon(
                FontAwesomeIcons.arrowLeft,
                size: 21,
              ),
              // FontAwesomeIcons.arrowLeft,
            )),
        Text(screenname ?? ""),
        Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
                border: Border.all(
                  strokeAlign: 0.8,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(8)),
            child: IconButton(
              onPressed: popmenu,
              icon: const Icon(
                FontAwesomeIcons.ellipsis,
                size: 21,
              ),
            ))
      ],
    );
  }
}

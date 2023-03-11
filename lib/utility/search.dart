import 'package:laundry_management_system/exports.dart';

class Search extends StatelessWidget {
  const Search({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(
        color: Colors.black,
        fontSize: 18,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(18),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white, width: 1)),
        hintText: "Search",
        prefixIconColor: Kinactivetextcolor,
        prefixIcon: const Icon(
          FontAwesomeIcons.search,
          size: 20,
        ),
      ),
    );
  }
}

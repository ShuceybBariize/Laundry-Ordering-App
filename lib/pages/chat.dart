import 'package:laundry_management_system/exports.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Column(children: const [Search()])),
      ],
    );
  }
}

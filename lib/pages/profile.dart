import '../exports.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            // backgroundColor: Color.fromARGB(26, 136, 134, 134),
            backgroundColor: Colors.grey.withOpacity(0.1),
            elevation: 0,
          ),
          backgroundColor: Colors.grey.withOpacity(0.1),
          body: SingleChildScrollView(
            child: Column(children: [
              const SizedBox(
                height: 13,
              ),
              SizedBox(
                height: 130,
                width: 130,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: const Image(
                    image: AssetImage("assets/shuceyb.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                "Shuceyb Bariize",
                style: GoogleFonts.inter(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              Text("shuceybbariize@Gmail.com",
                  style: GoogleFonts.inter(
                      fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 30,
              ),
              const menu_Profile(
                  profilename: "Account", profileicon: MdiIcons.account),
              const SizedBox(
                height: 14,
              ),
              const menu_Profile(
                  profilename: "Language", profileicon: MdiIcons.web),
              const SizedBox(
                height: 14,
              ),
              const menu_Profile(
                  profilename: "Notification", profileicon: MdiIcons.bell),
              const SizedBox(
                height: 14,
              ),
              const menu_Profile(
                  profilename: "Preference", profileicon: MdiIcons.cog),
              const SizedBox(
                height: 14,
              ),
              const menu_Profile(
                  profilename: "Help/Center", profileicon: MdiIcons.help),
            ]),
          )),
    );
  }
}

class menu_Profile extends StatelessWidget {
  final IconData profileicon;
  final String profilename;

  const menu_Profile({
    required this.profileicon,
    required this.profilename,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(left: 14, right: 14),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        horizontalTitleGap: 20,
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Kinactivetextcolor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Icon(profileicon, color: Kactivecolor, size: 28),
        ),
        title: Text(
          profilename,
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        trailing: Icon(
          FontAwesomeIcons.chevronRight,
          size: 20,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }
}
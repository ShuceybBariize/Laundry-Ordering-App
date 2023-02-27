import 'package:laundry_management_system/exports.dart';

class RegistorPage extends StatelessWidget {
  const RegistorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey.withOpacity(0.0),
            elevation: 0,
          ),
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 13, right: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomTitles(
                        subtitle: "Create New Account For You",
                        title: "Register"),
                    const Customtxt(
                        hinttxt: "Enter Username", txtfieldname: "Name"),
                    const Customtxt(
                        hinttxt: "Enter Your Email", txtfieldname: "Email"),
                    const Customtxt(
                        hinttxt: "Enter Password", txtfieldname: "Password"),
                    custombtn(
                        txtbtn: "Register",
                        onpress: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage())),
                        colorbtn: Kactivecolor,
                        colortxt: Colors.white),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                              color: Kinactivetextcolor,
                              fontSize: 17,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage())),
                          child: const Text("Login",
                              style: TextStyle(
                                  color: Kactivecolor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

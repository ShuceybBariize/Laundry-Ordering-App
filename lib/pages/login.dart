import 'package:laundry_management_system/exports.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
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
                        subtitle: "Login into your account",
                        title: "Lets get started"),
                    const Customtxt(
                        hinttxt: "Enter Your email", txtfieldname: "Email"),
                    const Customtxt(
                      sufficon: MdiIcons.eyeOffOutline,
                      suffclor: Colors.black,
                      hinttxt: "Enter Password",
                      txtfieldname: "Password",
                    ),
                    custombtn(
                        txtbtn: "Login",
                        onpress: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage())),
                        colorbtn: Kactivecolor,
                        colortxt: Colors.white),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Divider(
                          color: Kinactivetextcolor,
                          thickness: 1,
                        ),
                        Text("Or Login With account"),
                        Divider(
                          color: Kinactivetextcolor,
                          thickness: 1,
                          endIndent: 12,
                          height: 12,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account ?",
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
                                  builder: (context) => const RegistorPage())),
                          child: const Text("Register",
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

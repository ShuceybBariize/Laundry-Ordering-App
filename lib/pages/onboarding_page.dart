import '../exports.dart';
import 'login.dart';

class OnboardingPage extends StatelessWidget {
  static String id = 'onboardingPage';
  const OnboardingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        body: PageView(
          children: [
            Container(
              color: Kactivecolor,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(1),
                    child: Image.asset(
                      "assets/onbording.png",
                      fit: BoxFit.cover,
                      height: 350,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 50),
                    child: Text(
                      "The best solution for cleaning your clothes",
                      style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 35),
                    child: Text(
                      "Find the best and closest laundry place to you cleaned with the best washing machine so its doesn't reduce the quality of your clothes",
                      style: GoogleFonts.inter(
                        fontSize: 23,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  // const SizedBox(height: 43),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          custombtn(
                            colorbtn: Colors.white,
                            onpress: () => Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => const LoginPage(),
                                ),
                                (route) => false),
                            txtbtn: "Get Started",
                            colortxt: Kactivecolor,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
}

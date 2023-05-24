import 'package:laundry_management_system/exports.dart';

import '../utility/0nitems_list.dart';

class OrderList extends StatelessWidget {
  const OrderList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        FontAwesomeIcons.arrowLeft,
                        size: 21,
                      ),
                      // FontAwesomeIcons.arrowLeft,
                    )),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "Happy Laundry",
              style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  wordSpacing: 0.8,
                  fontSize: 25),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.all(14),
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 12,
                    spreadRadius: 0.1,
                    blurStyle: BlurStyle.normal,
                    offset: Offset(3, 7), // Shadow position
                  ),
                ],
                borderRadius: BorderRadius.circular(17),
                image: const DecorationImage(
                    image: AssetImage("assets/laundry.jpeg"),
                    alignment: Alignment.center,
                    fit: BoxFit.fill),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order List",
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Add Category",
                        style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Kactivecolor),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 233,
                        child: ListView(shrinkWrap: true, children: [
                          const SizedBox(
                            height: 20,
                          ),
                          OnItems(
                            imgcloth: const AssetImage("assets/jeans.jpg"),
                            pricecloth: "\$ 2",
                            typecloth: 'Jeans',
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          OnItems(
                              imgcloth: const AssetImage("assets/shoes.jpg"),
                              pricecloth: "\$ 3.5",
                              typecloth: 'Shoes'),
                          const SizedBox(
                            height: 20,
                          ),
                          OnItems(
                              imgcloth: const AssetImage("assets/shirt.jpg"),
                              pricecloth: "\$ 1",
                              typecloth: 'Shirt'),
                          const SizedBox(
                            height: 20,
                          ),
                          OnItems(
                              imgcloth: const AssetImage("assets/shirt.jpg"),
                              pricecloth: "\$ 1",
                              typecloth: 'Shirt'),
                        ]),
                      ),
                    ],
                  )
                ],
              ),
            ),
            // const SizedBox(
            //   height: 66,
            // ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    // color: Colors.black,
                    ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.all(8),
                                height: 60,
                                width: 60,
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 207, 206, 206),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: const Image(
                                  alignment: Alignment.center,
                                  image:
                                      AssetImage("assets/washing-machine.png"),
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Total Items",
                                    style: GoogleFonts.inter(
                                        color: Kinactivetextcolor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "4 Items",
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 110,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Cost",
                                      style: GoogleFonts.inter(
                                          color: Kinactivetextcolor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    "\$ 4 ",
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  )
                                ],
                              )
                            ],
                          ),
                          custombtn(
                              txtbtn: "CheckOut",
                              onpress: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage())),
                              colorbtn: Kactivecolor,
                              colortxt: Colors.white)
                        ]),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

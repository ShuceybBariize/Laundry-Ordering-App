import 'package:flutter/material.dart';

import 'admin_staffview.dart';
import 'userview.dart';

class UsersButton extends StatefulWidget {
  const UsersButton({super.key});

  @override
  State<UsersButton> createState() => _UsersButtonState();
}

class _UsersButtonState extends State<UsersButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Users view",
            style: TextStyle(fontSize: 25),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 20),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                "    Select Admin/Staff view",
                style: TextStyle(fontSize: 30, color: Colors.blue),
              ),
              const Text(
                "or",
                style: TextStyle(
                  height: 0.9,
                  fontSize: 30,
                ),
              ),
              const Text(
                "Customer view",
                style: TextStyle(height: 0.9, fontSize: 30, color: Colors.blue),
              ),
              const SizedBox(height: 28),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const UserScreen()));
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(10),
                      width: 200,
                      height: 180,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            opacity: 0.05,
                            image: AssetImage(
                              "assets/customer.png",
                            ),
                            fit: BoxFit.fill),
                        color: Colors.green,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(3, -4),
                            spreadRadius: 6,
                            blurRadius: 38,
                            color: Color.fromRGBO(0, 0, 0, 1),
                          ),
                        ],
                      ),
                      child: const Column(
                        children: [
                          Image(
                            image: AssetImage(
                              "assets/customer1.png",
                            ),
                            width: 100,
                            height: 100,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Customer view",
                            style: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AdminStafsUserview()));
                    },
                    child: Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(5),
                        width: 200,
                        height: 180,
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(3, -4),
                              spreadRadius: 6,
                              blurRadius: 38,
                              color: Color.fromRGBO(0, 0, 0, 1),
                            ),
                          ],
                        ),
                        child: const Column(
                          children: [
                            // Icon(
                            //   Icons.person,
                            //   size: 50,
                            // ),
                            SizedBox(height: 5),
                            Image(
                              image: AssetImage(
                                "assets/admin.png",
                              ),
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Admin/Staff view",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ],
          )),
        ),
      ),
    );
  }
}

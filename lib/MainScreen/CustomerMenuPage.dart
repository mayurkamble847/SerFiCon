// ignore_for_file: deprecated_member_use
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../List_of_owners/mess_owner_list.dart';
import '../List_of_owners/roomOwnerList.dart';
import '../User/userprofile.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);
  static String id = 'MenuPage';
  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  var role;
  bool isloding = false;
  var image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // ignore: deprecated_member_use
    findRole();
  }
  Future<void> retriveData() async {
    //print(uid);
    print("Hey your id is ${FirebaseAuth.instance.currentUser!.uid}");
    await FirebaseDatabase.instance
        .reference()
        .child('Users/all_users/${FirebaseAuth.instance.currentUser!.uid}')
        .once()
        .then((value) {
      setState(() {
        if (value.snapshot != null) {
          Map<dynamic, dynamic>? map = value.snapshot.value as Map?;
          image = map!['profile_image'];
        } else {
          print(value.snapshot.value);
        }
      });
    });
  }
  get() {
    return image == null
        ? const AssetImage('assets/images/profile_png.jpg')
        : NetworkImage(image);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloding == false
          ? CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          goToProfile();
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              get()
                        ),
                      ),
                    ],
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(20),
                    child: Container(
                      margin: const EdgeInsets.only(left: 4, right: 4),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.2),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                      //color: Colors.white,
                      width: double.maxFinite,
                      padding: const EdgeInsets.only(top: 15, bottom: 10),
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: const Center(
                          child: Text(
                            'Search for',
                            style: TextStyle(fontSize: 24, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  pinned: true,
                  backgroundColor: Colors.blueAccent.withOpacity(0.1),
                  expandedHeight: 380,
                  flexibleSpace: FlexibleSpaceBar(
                      background: Lottie.network(
                          'https://assets3.lottiefiles.com/packages/lf20_t7uqr8of.json')),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    //padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(left: 6, right: 6),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isloding = true;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Home()));
                            setState(() {
                              isloding = false;
                            });
                          },
                          child: Card(
                            elevation: 0,
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                              leading: const Icon(
                                Icons.home_outlined,
                                size: 30,
                              ),
                              subtitle: const Text(
                                'Find rooms and flats as per your need.',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                              title: const Text(
                                'Rooms',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 25),
                              ),
                              trailing: const Icon(
                                Icons.arrow_right_outlined,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isloding = true;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MessOwners()));
                            setState(() {
                              isloding = false;
                            });
                          },
                          child: Card(
                            elevation: 0,
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                              leading: const Icon(
                                Icons.food_bank_outlined,
                                size: 30,
                              ),
                              subtitle: const Text(
                                'Find best mess for you..',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                              title: const Text(
                                'Mess',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 25),
                              ),
                              trailing: const Icon(
                                Icons.arrow_right_outlined,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 450,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          : Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Colors.blueAccent,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Loading...',
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                )
              ],
            )),
    );
  }

  void goToProfile() {
    setState(() {
      isloding = true;
    });
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserProfile()));

    setState(() {
      isloding = false;
    });
  }

  void findRole() {
    if (FirebaseAuth.instance.currentUser != null) {
      var uid = FirebaseAuth.instance.currentUser!.uid;
      // ignore: deprecated_member_use
      FirebaseDatabase.instance
          .reference()
          .child('Users/all_users/$uid')
          .child('role')
          .once()
          .then((value) {
        role = value.snapshot.value.toString();
        print(role);
      });
    }
  }
}

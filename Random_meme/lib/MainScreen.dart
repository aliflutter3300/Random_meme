import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_meme/controllar/FetchMeme.dart';
import 'package:random_meme/controllar/saveMyData.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String imgUrl = "images/c.jpg";
  int memeNo = 0;
  bool isLoading = true;
  int targetMeme = 20;

  @override
  void initState() {
    super.initState();
    getInitMemeNo();
  }

  void getInitMemeNo() async {
    int? savedMemeNo = await SaveMyData.fetchData();
    if (savedMemeNo != null) {
      setState(() {
        memeNo = savedMemeNo;
        if (memeNo > 20) {
          targetMeme = 100;
        } else if (memeNo > 100) {
          targetMeme = 500;
        }
      });
    }
  }

  void updateImg() async {
    setState(() {
      isLoading = true;
    });

    String getImgUrl = await FetchMeme().fetchNewMeme();

    if (getImgUrl.isNotEmpty) {
      setState(() {
        imgUrl = getImgUrl;
        memeNo++;
        if (memeNo > 20 && memeNo <= 500) {
          targetMeme = 500;
        } else if (memeNo > 500) {
          targetMeme = 1000;
        }
        isLoading = false;
      });
      SaveMyData.saveData(memeNo);
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load image')),
      );
    }
  }

  void resetMeme() {
    setState(() {
      memeNo = 0;
      targetMeme = 20;
      imgUrl = "images/c.jpg"; // Resetting to default image
    });
    SaveMyData.saveData(memeNo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.purple],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 180,
                  decoration: BoxDecoration(
                    color: Color(0xffffeead),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'Meme# $memeNo',
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'Target Meme $targetMeme',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                isLoading
                    ? Container(
                  height: 400,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                )
                    : Container(
                  height: 400,
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(160, 60),
                        backgroundColor: Color(0xff6bf7aa),
                      ),
                      onPressed: () {
                        updateImg();
                      },
                      child: Text(
                        'More fun',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(160, 60),
                        backgroundColor: Colors.red.shade400,
                      ),
                      onPressed: () {
                        resetMeme();
                      },
                      child: Text(
                        'Reset Meme',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

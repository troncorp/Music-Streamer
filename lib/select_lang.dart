import 'package:flutter/material.dart';
import 'package:music_player/loading.dart';
import 'package:music_player/util/data.dart';

class SelectLang extends StatefulWidget {
  @override
  _SelectLangState createState() => _SelectLangState();
}

class _SelectLangState extends State<SelectLang> {
  bool isEngSel = true;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                height: 120,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isEngSel = true;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                  width: isEngSel ? width * 0.8 : width * 0.7,
                  height: isEngSel ? height * 0.25 : height * 0.2,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          isEngSel ? Colors.purple : Colors.blueAccent,
                          isEngSel ? Colors.blueAccent : Colors.purple
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black87,
                            blurRadius: isEngSel ? 30 : 0,
                            offset:
                                Offset(isEngSel ? 25 : 0, isEngSel ? 25 : 0))
                      ]),
                  child: Center(
                    child: Text(
                      "English",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isEngSel = false;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                  width: !isEngSel ? width * 0.8 : width * 0.7,
                  height: !isEngSel ? height * 0.25 : height * 0.2,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          !isEngSel ? Colors.purple : Colors.blueAccent,
                          !isEngSel ? Colors.blueAccent : Colors.purple
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black87,
                            blurRadius: !isEngSel ? 30 : 0,
                            offset:
                                Offset(!isEngSel ? 20 : 0, !isEngSel ? 20 : 0))
                      ]),
                  child: Center(
                    child: Text(
                      "Hindi",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                height: height * 0.07,
                minWidth: width * 0.3,
                onPressed: () {
                  kLangSel = isEngSel ? "ENG" : "HIN";
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoadingScreen()));
                },
                color: Colors.purpleAccent.withOpacity(0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text(
                  "Next",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

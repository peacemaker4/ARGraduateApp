import 'package:bouncing_button/bouncing_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController searchTextController = TextEditingController();

  Widget _bouncingButton(){
    return BouncingButton(
      upperBound: 0.1,
      duration: Duration(milliseconds: 100),
      child: Container(
        height: 45,
        width: 270,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromARGB(255, 57, 123, 255),
        ),
        child: const Center(
          child: Text(
            'Welcome home',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )),
        onPressed: (){
          
        }
    );
  }

  Widget _header(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20), 
      // child: Text("Home page", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
    );
  }

  Widget _search(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: CupertinoSearchTextField(
        padding: EdgeInsets.fromLTRB(5.5, 12, 5.5, 12),
        prefixInsets: EdgeInsets.all(10),
        suffixInsets: EdgeInsets.all(10),
        borderRadius: BorderRadius.circular(25),
        controller: searchTextController,
        placeholder: 'Search',
        onChanged: (value) {
          print(value);
        },
        onSubmitted: (value) {
          print(value);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 242, 244),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _search(),
            _header(),
            _bouncingButton()
          ]
        )
      )
    );
  }

}
import 'package:bouncing_button/bouncing_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ar_app/firebasedb.dart';

import '../auth.dart';

class RoleRequestModal extends StatefulWidget {
  RoleRequestModal({super.key, this.role="user"});

  String role;

  @override
  State<RoleRequestModal> createState() => _RoleRequestModalState(role);
}

class _RoleRequestModalState extends State<RoleRequestModal> {
  String role;

  bool requested = false;

  _RoleRequestModalState(this.role){}

  Widget _requestButton(){

    return FutureBuilder(
      future: FirebaseDB().firebaseRTDB.ref('role_requests/${Auth().currentUser?.uid}').once(), 
      builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Container(
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    color: Color.fromARGB(255, 171, 171, 171),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ));
                  }
          else{
            if(snapshot.hasData && snapshot.data?.snapshot.value != null){
            var data = snapshot.data!.snapshot.value as Map;
            return Container(
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: Color.fromARGB(255, 171, 171, 171),
              ),
              child: const Center(
                child: Text(
                  'Upload access requested',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            );
          }
          else{
            return BouncingButton(
                upperBound: 0.1,
                duration: Duration(milliseconds: 100),
                child: Container(
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    color: Color.fromARGB(255, 57, 123, 255),
                  ),
                  child: const Center(
                    child: Text(
                      'Request upload access',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )),
                  onPressed: () async {
                    var _firebaseRTDB = FirebaseDB().firebaseRTDB;
                    var uid = Auth().currentUser?.uid;
                    DatabaseReference ref = _firebaseRTDB.ref("role_requests/${uid}");
                    await ref.set({
                      "uid": uid,
                      "role": "member",
                      "date_time": DateTime.now().toString(),
                    });
                    setState(() {
                      requested = true;
                      // errorMsg = e.message;
                    });
                  }
              );
          }
          }
        
      }
    );

                 
  }

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          const SizedBox(height: 10,),
          Text('Role', 
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10,),
          Text('Current role: ${role}', 
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10,),
          Center(
            child: _requestButton(),

          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary,), // Set the button background color.
                onPressed: (){
                  Navigator.pop(context);
                },
                child:  Text("Close", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
              )
            ],
          )
        ]
      )
      ),
    );
  }
}
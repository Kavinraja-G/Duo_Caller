import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import './call.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();

  /// if channel textField is validated to have error
  bool _validateError = false;

  ClientRole _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Duo Caller'),
        backgroundColor: Colors.blue[900],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 15,
        onPressed: onJoin,
        child: Icon(
          Icons.call,
          color: Colors.blue[900],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.blue[900],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.history,
                  color: Colors.white,
                ),
                onPressed: () {}),
            IconButton(
                icon: Icon(
                  Icons.contacts,
                  color: Colors.white,
                ),
                onPressed: () {})
          ],
        ),
      ),

      body: Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(
              radius: 1,
              colors: [Colors.blue[800],Colors.white],  
              stops: [0.2, 1],   
            ),
        ),
        child: Center(
          child: SizedBox(
              height: 150,
              child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: TextField(
                            controller: _channelController,
                            decoration: InputDecoration(
                              errorText:
                                  _validateError ? 'Channel name is mandatory' : null,
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(width: 1),
                              ),
                              hintText: 'Channel name',
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ))
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Radio(
                          value: ClientRole.Broadcaster,
                          activeColor: Colors.blue[900],
                          groupValue: _role,
                          onChanged: (ClientRole value) {
                              setState(() {
                                _role = value;
                            });
                          },
                        ),
                        Text(
                          'Create',
                          style: TextStyle(
                          color: Colors.black,
                          ),
                        ),
                        Text("        "),
                        Text("        "),
                        Radio(
                            activeColor: Colors.blue[900],
                            value: ClientRole.Audience,
                            groupValue: _role,
                            onChanged: (ClientRole value) {
                              setState(() {
                                _role = value;
                              });
                            },
                        ),
                        Text(
                          'Join',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


//Joining the call 
  Future<void> onJoin() async {
    // update input validation
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (_channelController.text.isNotEmpty) {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic();
      // push video page with given channel name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: _channelController.text,
            role: _role,
          ),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}

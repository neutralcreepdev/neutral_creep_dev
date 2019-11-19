import 'package:flutter/material.dart';

import 'package:neutral_creep_dev/models/customer.dart';
import '../helpers/color_helper.dart';

class ProfilePage extends StatefulWidget {
  Customer customer;

  ProfilePage({this.customer});
  _ProfilePageState createState() => _ProfilePageState(customer: customer);
}

class _ProfilePageState extends State<ProfilePage> {
  Customer customer;
  _ProfilePageState({this.customer});
  String dropdownValue = 'One';
  String newValue = "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: alablaster,
        centerTitle: true,
        elevation: 0.2,
        iconTheme: IconThemeData(color: heidelbergRed, size: 30),
        title: Text(
          "Profile",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
              letterSpacing: 3),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              /*child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/testProfilePic.PNG'),
                radius: 40.0,
              ),*/
                child:Container(
                  decoration: new BoxDecoration(
                    // Circle shape
                      shape: BoxShape.circle,
                      // The border you want
                      border: new Border.all(
                        width: 1.0,
                        color: heidelbergRed,
                      ),
                  ),
                  child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/testProfilePic.PNG'),
                      radius: 40.0,
                  ),
                )
            ),
            Divider(
              height: 60.0,
              color: heidelbergRed,
            ),
            Text('Full Name: ',
                style: TextStyle(
                    color: heidelbergRed,
                    letterSpacing: 2.0,)),
            SizedBox(height: 10.0),
            Text(
              '${customer.lastName} ${customer.firstName}',
              style: TextStyle(
                  color: heidelbergRed,
                  letterSpacing: 2.0,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 25.0),
            Text('Address:',
                style: TextStyle(
                  color: heidelbergRed,
                  letterSpacing: 2.0,)),
            SizedBox(height: 10.0),
            Text(
              'Blk ${customer.address['unit']}\n${customer.address['street']}\nS(${customer.address['postalCode']})',
              style: TextStyle(
                  color: heidelbergRed,
                  letterSpacing: 2.0,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 25.0),
            Text('Contact Number:',
                style: TextStyle(
                  color: heidelbergRed,
                  letterSpacing: 2.0,)),
            SizedBox(height: 10.0),
            Text(
              '${customer.contactNum}',
              style: TextStyle(
                  color: heidelbergRed,
                  letterSpacing: 2.0,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30.0),
           /* Row(
              children: <Widget>[
                Icon(Icons.card_membership, color: heidelbergRed),
                //Add a drop downOption to see which card is already in the account
                Text("CardInfo",
                    style: TextStyle(
                      color: heidelbergRed,
                      fontSize: 18.0,
                      letterSpacing: 1.0,
                    ))
              ],
            ),*/
           SizedBox(height: 10.0),
            Text('Current CreditCards:',
                style: TextStyle(
                  color: heidelbergRed,
                  letterSpacing: 2.0,)),
            Row(
              children: <Widget>[Icon(Icons.card_membership),
                SizedBox(width: 10,),
                DropdownButton<String>(
                  value: dropdownValue,
                  style: TextStyle(
                      color: Colors.deepPurple
                  ),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      print('$newValue');
                      dropdownValue = newValue;
                    });
                  },
                  items: <String>['One', 'Two', 'Free', 'Four']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Text('a$dropdownValue'),
            SizedBox(height: 10.0,),
            Row(
              children: <Widget>[
                Icon(Icons.add, color: heidelbergRed),
                //Add a drop downOption to see which card is already in the account
                Text("Add a new credit Card:",
                    style: TextStyle(
                      color: heidelbergRed,
                      fontSize: 18.0,
                      letterSpacing: 1.0,
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

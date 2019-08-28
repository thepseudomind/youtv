import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped_models/main.dart';
import '../pages/auth.dart';

class SettingsPage extends StatefulWidget {
  final MainModel model;
  SettingsPage(this.model);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool nightModeValue, imageQualityValue;

  void initState(){
    super.initState();
    nightModeValue = widget.model.darkMode;
    imageQualityValue = false;
  }

  CheckboxListTile darkModeToggle(Function changeMode){
    return CheckboxListTile(
      title: Text('Night Mode'),
      value: nightModeValue,
      onChanged: (bool value){
        setState(() {
          nightModeValue = value;
          changeMode(nightModeValue);
          if(nightModeValue == true){
            print('Dark mode activated');
          }
        });
      },
    );
  }

  SwitchListTile imageQualityToggle(){
    return SwitchListTile(
      title: Text('Image Quality'),
      subtitle: (imageQualityValue) ? Text('High') : Text('Low'),
      value: imageQualityValue,
      onChanged: (bool value){
        setState(() {
          imageQualityValue = value;
        });
      }
    );
  }

  ListTile subscribeTile(){
    return ListTile(
      title: Text('Subscribe'),
      onTap: ()=> Navigator.pushReplacementNamed(context, '/subscribe')
    );
  }

  ListTile feedbackDialogBox(){
    return ListTile(
      title: Text('Send Feedback'),
      onTap: (){
        showDialog(
          context: context,
          builder: (BuildContext context){
            if(Platform.isAndroid){
              return SimpleDialog(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal : 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        TextField(
                          onChanged: (value){

                          },
                          decoration: InputDecoration(
                            hintText: 'Send us your feedback'
                          )
                        ),
                        SizedBox(height: 5.0),
                        ButtonBar(
                          children: <Widget>[
                            GestureDetector(
                              onTap: ()=> Navigator.pop(context),
                              child: Text('CANCEL', style: TextStyle(color: Theme.of(context).primaryColor))
                            ),
                            GestureDetector(
                              onTap: ()=> Navigator.pop(context),
                              child: Text('SEND', style: TextStyle(color: Theme.of(context).primaryColor))
                            )
                          ],
                        )
                      ],
                    )
                  )
                ]
              );
            }else if(Platform.isIOS){
              return CupertinoAlertDialog(
                content: CupertinoTextField(
                  onChanged: (value){

                  },
                  placeholder: 'Send us your feedback',
                  maxLines: 4,
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    onPressed: ()=> Navigator.pop(context),
                    child: Text('CANCEL', style: TextStyle(color: Theme.of(context).primaryColor))
                  ),
                  CupertinoDialogAction(
                    onPressed: (){},
                    child: Text('SEND', style: TextStyle(color: Theme.of(context).primaryColor))
                  )
                ],
              );
            }
          }
        );
      },
    );
  }

  ListTile termsAndConditionsDialogBox(){
    return ListTile(
      title: Text('Terms and Conditions'),
      onTap: (){
        showDialog(
          context: context,
          builder: (BuildContext context){
            return AboutDialog(
              applicationName: 'YOUtv',
              applicationIcon: Image.asset('assets/sample-logo.png', height: 50.0),
              applicationVersion: '1.0.0',
              children: <Widget>[
                Text('TERMS OF USE', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5.0),
                Text('Welcome to YOUtvafica.com (the \"Site or application\"), owned and operated by YOUtv, powered by Black Collar 360Media Partners Limited. We are a company registered in Nigeria, and our address for correspondence is S105 Unit 2, road 7, Lekki Gardens Phase 2 Ajah Lagos. We are a subscription service that provides our members (\"you\" \"yourself\" \"Users\") with access to content including but not limited to access to motion pictures, television and other audio-visual entertainment (\"content\") delivered over the web. These Terms of Use, including our Privacy Policy govern your use of our service. As used in these Terms of Use, \"YOUtv services\" means the subscription service provided by YOU for discovering and watching the content, including all features and functionality, the Site, content, application, user interface and software\'s associated with our service.'),
                SizedBox(height: 20.0),
                Text('ACCEPTANCE OF TERMS OF USE', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5.0),
                Text('By accessing, visiting, using or browsing the YOUtv services, via this Site or application or other technology, you accept and agree to be bound by the Terms. Please read carefully. Further, you shall be subject to any additional terms of use that apply when you use certain products (for example, a voucher) or posted guidelines or rules applicable to our service, which may be posted and modified from time to time. All such guidelines are hereby incorporated by reference into the Terms.'),
                Text('\n ANY ACCESS, USE or PARTICIPATION IN THE YOUtv SERVICE WILL CONSTITUTE ACCEPTANCE OF THE TERMS. IF YOU DO NOT AGREE TO THESE TERMS OF USE, PLEASE DO NOT USE THE YOUtv SERVICE OR OUR SITE OR APPLICATION OR ACCESS OUR SERVICE.', style: TextStyle(fontStyle: FontStyle.italic)),
                SizedBox(height: 20.0),
                Text('PRIVACY', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5.0),
                Text('Please read our privacy policy here http://pre-youtvafrica.com/privacy, which also governs your use of the Site and application and our service, to understand our practices.'),
                SizedBox(height: 20.0),
                Text('COMMUNICATIONS', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5.0),
                Text('By using the YOUtv services, you consent to receiving electronic communication from YOUtv relating to your account. We will communicate with you by e-mail, or by posting notices on the Site or application or through other YOUtv methods. For contractual purposes, you consent to receive communications from us electronically and you agree that all agreements, notices, disclosures and other communications that we provide you electronically satisfy any legal requirement that such communication be in writing. You also consent to receiving certain other communication from us, such as newsletters, special offers, questionnaires, customer surveys or other announcements via email or other methods. You may opt out of receiving non-transactional communications, including marketing communications from us by following the directions in our e-mail to “unsubscribe” from our mailing list, or by sending an e-mail request to support@youtvafricamail.com. Please be aware that if you choose not to receive such communication, certain offers attached to services you have chosen may be affected. We will still communicate with you in connection with transactional communications, including but not limited to servicing your account, invoices and customer services.'),
                SizedBox(height: 20.0),
                Text('YOUtv SERVICE', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5.0),
                Text('In order to access our service, you will have to create an account with YOUtv by formally registering on the application. You must be 18 years of age, or the age of majority in your province, territory or country, to become a member of the YOUtv service. Individuals under the age of 18, or applicable age of majority, may utilize the service only with the involvement of a parent or legal guardian, under such person\'s account and otherwise subject to these Terms.'),
                Text('\n Restrictions', style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 5.0),
                Text('You agree to use the YOUtv service, including all features and functionalities associated therewith, in accordance with all applicable laws, rules and regulations, including public performance limitations or other restrictions on use of the service or content therein. In addition, you agree that:'),
                SizedBox(height: 5.0),
                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: Column(
                    children: <Widget>[
                      Text('• You are prohibited from reproducing, modifying, copying, uploading, exporting, transferring, selling, forwarding or transmitting the Contents on the Site or in the application other than in accordance with the license granted and further not to reproduce any information of the Site or in the application on any other website', style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic, fontWeight: FontWeight.w600)),
                      Text('\n• You may not either directly or through the use of any device, software, internet site, web-based service, or other means remove, alter, bypass, avoid, interfere with, or circumvent any copyright, trademark, or other proprietary notices marked on the content or any digital rights management mechanism, device, or other content protection or access control measure associated with the content including geo-filtering mechanisms.', style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic, fontWeight: FontWeight.w600)),
                      Text('\n•	You may not either directly or through the use of any device, software, internet site, web-based service, or other download, stream, (except as explicitly authorized in these Terms) copy, capture, reproduce, duplicate, archive, distribute, upload, publish, modify, translate, broadcast, perform, display, sell, transmit or retransmit the content unless expressly permitted by YOUtv in writing.', style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic, fontWeight: FontWeight.w600)),
                      Text('\n•	You may not incorporate the content into, or stream or retransmit the content via, any hardware or software application or make it available via frames or in-line links unless expressly permitted by YOUtv in writing. Furthermore, you may not create, recreate, distribute or advertise an index of any significant portion of the content unless authorized.', style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic, fontWeight: FontWeight.w600)),
                      Text('\n•	You may not circumvent, remove, alter, deactivate, degrade or thwart any of the content protections in the YOUtv service; use any robot, spider, scraper or other automated means to access the YOUtv service; decompile, reverse engineer or disassemble any software or other products or processes accessible through the YOUtv service; insert any code or product or manipulate the content of the YOUtv service in any way; or, use any data mining, data gathering or extraction method.', style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic, fontWeight: FontWeight.w600)),
                      Text('\n•	You shall not upload, post, e-mail or otherwise send or transmit any material designed to interrupt, destroy or limit the functionality of any computer software or hardware or telecommunications equipment associated with the YOUtv service, including any software viruses or any other computer code, files or programs.', style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic, fontWeight: FontWeight.w600)),
                    ]
                  )
                )
              
              ],
            );
          }
        );
      },
    );
  }

  ListTile versionIndicator(){
    return ListTile(
      title: Text('Version'),
      subtitle : Text('1.0.0'),
    );
  }

  ListTile appShare(){
    return ListTile(
      title: Text('Share this app'),
      onTap: (){}
    );
  }

  ListTile aboutYOUtv(){
    return ListTile(
      title: Text('About YOUtv'),
      onTap: ()=> Navigator.pushNamed(context, '/about')
    );
  }

  void signOut(){
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (BuildContext context) => AuthPage()
    ));
  }

  ListTile signOutTile(Function logOut){
    return ListTile(
      title: Text('Sign Out'),
      onTap: () async{
        await logOut(signOut);
      }
    );
  }

  Widget downloadsTile(){
    if(Platform.isIOS){
      return Column(
        children: <Widget>[
          Divider(),
          ListTile(
            title: Text('Downloads'),
            onTap: (){}
          ),
          // Divider()
        ],
      );
    }else{
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model){
        return Scaffold(
          appBar: AppBar(
            backgroundColor: (model.darkMode) ? Color(0xFF20242F) : Theme.of(context).primaryColor,
            leading: (Platform.isIOS) ? Container() : null,
            title: Text('Settings')
          ),
          body: ListView(
            children: <Widget>[
              darkModeToggle(model.changeMode),
              downloadsTile(),
              Divider(),
              subscribeTile(),
              Divider(),
              feedbackDialogBox(),
              Divider(),
              termsAndConditionsDialogBox(),
              Divider(),
              versionIndicator(),
              Divider(),
              appShare(),
              Divider(),
              aboutYOUtv(),
              Divider(),
              signOutTile(model.signOut)
            ]
          )  
        );
      }
    );
  }
}


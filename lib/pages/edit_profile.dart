import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped_models/main.dart';

class EditProfilePage extends StatefulWidget {
  final MainModel model;
  EditProfilePage(this.model);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File image, imageFile;
  String nameValue, phoneValue;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  Future<void> chooseImage(ImageSource source) async{
    image = await ImagePicker.pickImage(source: source);
    setState(() {
      imageFile = image;
    });
  }

  void imageToUpload(){
    if(widget.model.displayPicture != null){
      setState(() {
        imageFile = widget.model.displayPicture;
      });
    }else{
      setState(() {
        imageFile = null;
      });
    }
  }

  void removeImage(){
    setState(() {
      imageFile = null;
    });
  }

  void confirmDetails(){
    emailController.text = widget.model.signedInUser.email;
    if(widget.model.signedInUser.displayName != null){
      nameController.text = widget.model.signedInUser.displayName;
      nameValue = nameController.text;
    }
    if(widget.model.userPhoneNumber != null){
      phoneController.text = widget.model.userPhoneNumber;
      phoneValue = phoneController.text;
    }
  }

  @override
  void initState() {
    imageToUpload();
    confirmDetails();
    super.initState();
  }

  TextField nameField(){
    return TextField(
      controller: nameController,
      decoration: InputDecoration(
        labelText: 'Name'
      ),
      onChanged: (String value){
        setState(() {
          nameValue = value;
        });
      },
    );
  }

  TextField emailField(){
    return TextField(
      enabled: false,
      controller: emailController,
      decoration: InputDecoration(
        labelText: 'Email Address'
      )
    );
  }

  TextField phoneNumberField(){
    return TextField(
      controller: phoneController,
      decoration: InputDecoration(
        labelText: 'Phone Number'
      ),
      onChanged: (String value){
        setState(() {
          phoneValue = value;
        });
      },
    );
  }

  Widget imagePickerBtn(BuildContext context, MainModel model){
    return RaisedButton(
      color: Theme.of(context).primaryColor,
      onPressed: (){
        showModalBottomSheet(
          context: context,
          builder: (context){
            return Container(
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: ()=> chooseImage(ImageSource.gallery),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 25.0,
                          child: Icon(Icons.perm_media, color: Colors.white)
                        ),
                        SizedBox(height: 5.0),
                        Text('Choose from Gallery'),
                      ]
                    ),
                  ),
                  GestureDetector(
                    onTap: ()=> chooseImage(ImageSource.camera),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.teal,
                          radius: 25.0,
                          child: Icon(Icons.camera_alt, color: Colors.white)
                        ),
                        SizedBox(height: 5.0),
                        Text('Use Camera')
                      ]
                    )
                  )
                ],
              )
            );
          }
        );
      },
      child: (model.displayPicture == null) ? Text('Set profile picture', style: TextStyle(color: Colors.white)) : Text('Change profile picture', style: TextStyle(color: Colors.white))
    );
  }

  Widget removeImageBtn(MainModel model){
    if(imageFile == null){
      return Container();
    }else{
      return RaisedButton(
        color: Colors.white,
        onPressed: (){
          removeImage();
          model.removeDisplayPicture();
          Navigator.pushNamed(context, '/profile');
        },
        child: Text('Remove picture')
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model){
        return Scaffold(
          appBar: AppBar(
            title: Text('Edit proile'),
            actions: <Widget>[
              IconButton(
                onPressed: (){
                  print(nameValue);
                  print(phoneValue);
                  print(imageFile.path);
                  model.updateProfile(nameValue, phoneValue, imageFile);
                  Navigator.pushNamed(context, '/home');
                },
                icon: Icon(Icons.check)
              )
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                nameField(),
                emailField(),
                phoneNumberField(),
                SizedBox(height: 10.0),
                (imageFile == null) ? Text('No image to preview') : Image.file(imageFile, fit: BoxFit.cover, height: 200),
                SizedBox(height: 10.0),
                imagePickerBtn(context, model),
                SizedBox(height: 2.5),
                removeImageBtn(model)
              ]
            )
          )
        );
      }
    );
  }
}
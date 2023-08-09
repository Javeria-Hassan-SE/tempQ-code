import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../components/transaparentHeaderAppBar.dart';
import '../../../constants/constants.dart';
import '../../../models/userModel.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class EditImagePage extends StatefulWidget {
  const EditImagePage({Key? key}) : super(key: key);

  @override
  _EditImagePageState createState() => _EditImagePageState();
}

class _EditImagePageState extends State<EditImagePage> {
  var user = UserModel.myUser;
  bool loading =false;

  Future updateUserImage() async {
    Map<String, dynamic> data = {"userId":user.userId,
      "userImage":user.userImage};
    String jsonData = json.encode(data);
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/user_profile/update_user_image.php');

    var response = await http.post(url,
        headers: {"Accept":"application/json"},
        body: jsonData);

    if (response.statusCode == 200) {
      var msg = json.decode(response.body);
      return msg;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: transparentHeaderAppBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
              width: 330,
              child: Text(
                "Upload a photo of yourself:",
                style: TextStyle(
                  fontSize: 23,
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                  width: 330,
                  child: GestureDetector(
                    onTap: () async {
                      final image = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);

                      if (image == null) return;

                      final location = await getApplicationDocumentsDirectory();
                      final name = basename(image.path);
                      final imageFile = File('${location.path}/$name');
                      final newImage =
                          await File(image.path).copy(imageFile.path);
                      setState(
                          () => user = user.copy(userImage: newImage.path));
                    },
                    child: Image.asset(user.userImage!),
                  ))),
          Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 330,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          loading=false;
                        });
                        var response = await updateUserImage();
                        if(response=="Success"){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Updated Successfully',
                                style: TextStyle(fontSize: 16, color: Colors.green),
                              )));
                          Navigator.pop(context);
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Failed to update',
                                style: TextStyle(fontSize: 16, color: Colors.green),
                              )));
                        }
                        setState(() {
                          loading=false;
                        });
                      },
                      child: const Text(
                        'Update',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ))),
          !loading
              ?const Text("")
              :const CircularProgressIndicator(
            color: Colors.green,
          )
        ],
      ),
    );
  }
}

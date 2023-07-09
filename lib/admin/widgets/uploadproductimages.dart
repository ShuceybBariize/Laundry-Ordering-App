import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../exports.dart';

class UploadImages extends ChangeNotifier {
  File? _image;
  String? _imageUrl;

  File? get image => _image;
  String? get imageUrl => _imageUrl;
  String? imageURL;
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      File? croppedImage = await _cropImage(File(pickedFile.path));
      // _image = File(pickedFile.path);
      if (croppedImage != null) {
        _image = croppedImage;
        uploadImageToFirebase();
        notifyListeners();
      }
    }
  }

  Future<void> uploadImageToFirebase() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    // collaction of customer
    // final custCollection = FirebaseFirestore.instance.collection("productdb");
    if (_image != null) {
      try {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('images/${DateTime.now().millisecondsSinceEpoch}.png');
        UploadTask uploadTask = storageReference.putFile(_image!);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        // _imageUrl = downloadUrl;

        //  // await custCollection
        //       .doc(currentUser!.uid)
        //       .set({'imageUrl': downloadUrl});

        notifyListeners();
        print('Image uploaded. Download URL: $downloadUrl');

        // Store the image URL in the "profile_image" collection in Firestore
        // FirebaseFirestore.instance.collection('imgProfileCustomer').add({
        //   'image_url': downloadUrl,
        //   'timestamp': FieldValue.serverTimestamp(),
        // });
        imageURL = downloadUrl;
        //   return downloadUrl;
        print('Image URL stored in Firestore');
      } catch (error) {
        // Handle any errors that occur during image upload
        print('Image upload failed. Error: $error');
      }
    } else {
      print('No image selected');
    }
  }

  Future<File?> _cropImage(File imageFile) async {
    File? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio16x9,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio7x5,
            ],
      androidUiSettings: const AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      iosUiSettings: const IOSUiSettings(
        title: 'Crop Image',
      ),
    );

    return croppedFile;
  }
}

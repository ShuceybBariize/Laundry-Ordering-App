import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
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
      _image = File(pickedFile.path);
      uploadImageToFirebase();
      notifyListeners();
      // if (croppedImage != null) {
      //   _image = croppedImage;

      // }
    }
  }

  Future<void> uploadImageToFirebase() async {
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

//  Future<CroppedFile?> _cropImage(File imageFile) async {
//     final croppedFile = await ImageCropper().cropImage(
//         sourcePath: imageFile.path,
//         aspectRatioPresets: Platform.isAndroid
//             ? [
//                 CropAspectRatioPreset.square,
//                 CropAspectRatioPreset.original,
//                 CropAspectRatioPreset.ratio3x2,
//                 CropAspectRatioPreset.ratio4x3,
//                 CropAspectRatioPreset.ratio16x9
//               ]
//             : [
//                 CropAspectRatioPreset.original,
//                 CropAspectRatioPreset.square,
//                 CropAspectRatioPreset.ratio16x9,
//                 CropAspectRatioPreset.ratio3x2,
//                 CropAspectRatioPreset.ratio5x3,
//                 CropAspectRatioPreset.ratio4x3,
//                 CropAspectRatioPreset.ratio7x5,
//               ],
//         uiSettings: [
//           AndroidUiSettings(
//               toolbarTitle: "Image Cropper",
//               toolbarColor: Colors.orange,
//               toolbarWidgetColor: Colors.white,
//               initAspectRatio: CropAspectRatioPreset.original,
//               lockAspectRatio: false),
//           IOSUiSettings(
//             title: "Image Corpper",
//           )
//         ]);

//     return croppedFile;
//   }
}

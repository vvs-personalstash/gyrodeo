import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import './main.dart';

class PickFile extends StatefulWidget {
  const PickFile({Key? key}) : super(key: key);

  @override
  State<PickFile> createState() => _PickFileState();
}

class _PickFileState extends State<PickFile> {
  PickedFile? _pickedFile;
  final ImagePicker picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: TextButton(
      onPressed: () async {
        _pickedFile = await picker.getVideo(
          source: ImageSource.gallery,
        );
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => VideoApp(VideoPath: _pickedFile!.path)));
      },
      child: Text(
        "Upload Video",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    )));
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:app_client/src/model/user.dart';
import 'package:app_client/src/util/behavior.dart';
import 'package:app_client/src/util/button.dart';
import 'package:app_client/src/util/loading.dart';
import 'package:app_client/src/views/app/bloc/user_bloc.dart';
import 'package:app_client/src/views/app/personal/crop_image_bloc.dart';
import 'package:app_client/src/views/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  CropperBloc cropperBloc = CropperBloc();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    final userBloc = BlocProvider.of<UserBloc>(context);
    nameController.text = userBloc.state.user.name ?? "";
    phoneController.text = userBloc.state.user.phone ?? "";
    addressController.text = userBloc.state.user.address ?? "";
    super.initState();
  }

  void _updateUser(BuildContext context, String photo, String name,
      String phone, String address) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    userBloc.add(UpdateUserEvent(
        user: User(address: address, phone: phone, photo: photo, name: name)));
  }

  @override
  void dispose() {
    nameController.clear();
    phoneController.clear();
    addressController.clear();
    super.dispose();
  }

  void _getFromgallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxHeight: 1080,
      maxWidth: 1080,
    );

    _cropImage(pickedFile!.path);
  }

  void _cropImage(filePath) async {
    File? croppedImage = await ImageCropper().cropImage(
        sourcePath: filePath,
        maxHeight: 1080,
        maxWidth: 1080,
        compressQuality: 40,
        compressFormat: ImageCompressFormat.png,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: kPrimaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedImage != null) {
      cropperBloc.add(croppedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: const Color.fromARGB(60, 101, 101, 101),
        elevation: 10,
        toolbarHeight: 55,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          "Chỉnh sửa tài khoản",
          style: GoogleFonts.openSans(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        leading: SizedBox(
          height: 40,
          width: 40,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 26,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        padding: const EdgeInsets.all(kDefautPadding / 2),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              width: size.width - kDefautPadding,
              height: size.height - 55 - 2 * kDefautPadding,
              padding: const EdgeInsets.all(kDefautPadding / 2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kDefautPadding / 2),
                  color: Colors.white),
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  return Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 50),
                            GestureDetector(
                              onTap: () {},
                              child: Stack(
                                children: [
                                  _buildPhoto(state),
                                  Positioned(
                                      bottom: 5,
                                      right: 15,
                                      child: GestureDetector(
                                        onTap: () => _getFromgallery(),
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Colors.blue),
                                          child: const Icon(
                                              Icons.camera_alt_rounded,
                                              color: Colors.white,
                                              size: 24),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Form(
                              child: Column(
                                children: [
                                  _buildTextField(
                                    size,
                                    nameController,
                                    "Tên của bạn",
                                    Icons.person,
                                  ),
                                  _buildTextField(
                                    size,
                                    phoneController,
                                    "Số điện thoại",
                                    Icons.phone,
                                  ),
                                  _buildTextField(
                                    size,
                                    addressController,
                                    "Địa chỉ",
                                    Icons.location_on_outlined,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            StreamBuilder<File>(
                                stream: cropperBloc.cropperStream,
                                builder: (context, snapshot) {
                                  return CustomButton(
                                    onPressed: () => _updateUser(
                                        context,
                                        base64Encode(
                                            snapshot.data!.readAsBytesSync()),
                                        nameController.text,
                                        phoneController.text,
                                        addressController.text),
                                    text: "Cập nhật",
                                    width: 150,
                                    height: 40,
                                    icon: Icons.upload_rounded,
                                  );
                                }),
                            const SizedBox(height: 20),
                          ]),
                      Positioned(
                          top: 0,
                          bottom: 0,
                          child: state.isLoading == true
                              ? LoadingWidget(
                                  height: size.height - 55 - 2 * kDefautPadding)
                              : Container())
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Container _buildBottomSheet(BuildContext context, Size size) => Container(
  //       height: 100,
  //       decoration: BoxDecoration(
  //           color: Colors.white,
  //           boxShadow: [Shadown.shadown],
  //           borderRadius: const BorderRadius.only(
  //             topLeft: Radius.circular(10),
  //             topRight: Radius.circular(10),
  //           )),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
  //         children: [
  //           IconButton(
  //             onPressed: () => _getFromCamenra(),
  //             icon: const Icon(Icons.camera_alt_rounded, size: 30),
  //           ),
  //           IconButton(
  //             onPressed: () => _getFromgallery(),
  //             icon: const Icon(
  //               Icons.image_rounded,
  //               size: 30,
  //             ),
  //           )
  //         ],
  //       ),
  //     );

  Widget _buildTextField(Size size, TextEditingController controller,
          String hText, IconData icon) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.only(bottom: kDefautPadding / 1),
        width: size.width - 4 * kDefautPadding,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: kBorderColor),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: 24),
            Expanded(
              flex: 1,
              child: TextField(
                controller: controller,
                cursorColor: Colors.black,
                style: GoogleFonts.openSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: textColor),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(
                        left: 15, bottom: 10, top: 11, right: 15),
                    hintText: hText,
                    hintStyle: GoogleFonts.openSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: textColor.withOpacity(0.7))),
              ),
            ),
          ],
        ),
      );

  Container _buildPhoto(UserState state) => Container(
        width: 150,
        height: 150,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(150),
          border: Border.all(color: kBorderColor, width: 3),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(150),
          child: StreamBuilder<File>(
              stream: cropperBloc.cropperStream,
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return Image.file(
                    snapshot.data!,
                    fit: BoxFit.cover,
                  );
                }
                return CachedNetworkImage(
                  imageUrl: state.user.photo ?? "",
                  fit: BoxFit.cover,
                );
              }),
        ),
      );
}

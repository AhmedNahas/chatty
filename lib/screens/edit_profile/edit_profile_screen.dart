import 'package:chatty/components/reusable_comp/widgets/reusable_component.dart';
import 'package:chatty/constants/constants.dart';
import 'package:chatty/main_cubit/cubit.dart';
import 'package:chatty/main_cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var bioController = TextEditingController();
    var phoneController = TextEditingController();

    return BlocConsumer<MainCubit, MainCubitStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        var cubit = MainCubit.get(context);

        nameController.text = userModel!.name;
        bioController.text = userModel!.bio;
        phoneController.text = userModel!.phone;

        ImageProvider showProfileImage() {
          if (cubit.profileImage == null) {
            return NetworkImage(userModel!.image);
          } else {
            return FileImage(cubit.profileImage!);
          }
        }

        ImageProvider showCoverImage() {
          if (cubit.coverImage == null) {
            return NetworkImage(userModel!.cover);
          } else {
            return FileImage(cubit.coverImage!);
          }
        }

        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: "Edit Profile",
            actions: [
              OutlinedButton(
                onPressed: () {
                  cubit.updateUserDate(
                      name: nameController.text,
                      phone: phoneController.text,
                      bio: bioController.text);
                },
                child: const Text(
                  'Update',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
            showLeading: true,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is UpdateUserDataLoadingState)
                    const LinearProgressIndicator(minHeight: 8.0,),
                  SizedBox(
                    height: 250.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.topCenter,
                              child: Container(
                                height: 180.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: showCoverImage(),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                  child: IconButton(
                                icon: const Icon(Icons.camera_alt_outlined),
                                onPressed: () {
                                  cubit.getCoverImage();
                                },
                              )),
                            )
                          ],
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 64.0,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 60.0,
                                backgroundImage: showProfileImage(),
                              ),
                            ),
                            CircleAvatar(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 15.0,
                                ),
                                onPressed: () {
                                  cubit.getProfileImage();
                                },
                              ),
                              radius: 15.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  defaultTextFormField(
                      controller: nameController,
                      validate: (String? v) {
                        if (v!.isEmpty) {
                          return "Name is required";
                        }
                        return null;
                      },
                      inputType: TextInputType.name,
                      label: "Name",
                      icon: const Icon(Icons.person)),
                  const SizedBox(
                    height: 10.0,
                  ),
                  defaultTextFormField(
                      controller: bioController,
                      validate: (String? v) {
                        if (v!.isEmpty) {
                          return "Bio is required";
                        }
                        return null;
                      },
                      inputType: TextInputType.text,
                      label: "Bio",
                      icon: const Icon(Icons.info_outline)),
                  const SizedBox(
                    height: 10.0,
                  ),
                  defaultTextFormField(
                      controller: phoneController,
                      validate: (String? v) {
                        if (v!.isEmpty) {
                          return "phone is required";
                        }
                        return null;
                      },
                      inputType: TextInputType.phone,
                      label: "Phone",
                      icon: const Icon(Icons.mobile_screen_share)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

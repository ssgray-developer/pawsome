import 'dart:io';
import 'dart:typed_data';
import 'package:currency_picker/currency_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pawsome/common/enums.dart';
import 'package:pawsome/core/theme/app_colors.dart';
import 'package:pawsome/data/pet/models/pet_registration_req.dart';
import 'package:pawsome/presentation/bloc/image_picker/image_picker_cubit.dart';
import 'package:pawsome/presentation/profile/bloc/register_pet_cubit.dart';
import '../../../common/animal_list.dart';
import '../../../core/theme/app_strings.dart';
import '../widgets/adoption_form_field.dart';

class PetAdoptionListing extends StatefulWidget {
  const PetAdoptionListing({super.key});

  @override
  PetAdoptionListingState createState() => PetAdoptionListingState();
}

class PetAdoptionListingState extends State<PetAdoptionListing> {
  bool isHybrid = false;
  bool isEnabled = false;
  bool isLoading = false;

  PetGender selectedGender = PetGender.Male;
  String currencyCode = '-';
  Uint8List? image;
  String? selectedSpeciesInFirstDropdown;
  List<String> selectedSpeciesList = birdSpecies;
  String selectedPetClass = AppStrings.bird;

  final List<bool> selectedGenderList = [true, false];
  late Map<String, List<List<String>>> animalMap;

  late GlobalKey<FormState> nameFormKey;
  late GlobalKey<FormState> ageFormKey;
  late GlobalKey<FormState> priceFormKey;
  late GlobalKey<FormState> reasonFormKey;

  late GlobalKey<DropdownSearchState<String>> petClassKey;
  late GlobalKey<DropdownSearchState<String>> firstSpeciesKey;
  late GlobalKey<DropdownSearchState<String>> secondSpeciesKey;

  late ScrollController scrollController;

  late FocusNode petNameFocusNode;
  late FocusNode petAgeFocusNode;
  late FocusNode reasonFocusNode;
  late FocusNode priceFocusNode;

  late TextEditingController petNameTextEditingController;
  late TextEditingController petAgeTextEditingController;
  late TextEditingController reasonTextEditingController;
  late TextEditingController priceTextEditingController;

  @override
  void initState() {
    super.initState();
    nameFormKey = GlobalKey<FormState>();
    ageFormKey = GlobalKey<FormState>();
    priceFormKey = GlobalKey<FormState>();
    reasonFormKey = GlobalKey<FormState>();

    petClassKey = GlobalKey<DropdownSearchState<String>>();
    firstSpeciesKey = GlobalKey<DropdownSearchState<String>>();
    secondSpeciesKey = GlobalKey<DropdownSearchState<String>>();

    scrollController = ScrollController();

    petNameTextEditingController = TextEditingController();
    petAgeTextEditingController = TextEditingController();
    reasonTextEditingController = TextEditingController();
    priceTextEditingController = TextEditingController();

    petNameFocusNode = FocusNode();
    petAgeFocusNode = FocusNode();
    reasonFocusNode = FocusNode();
    priceFocusNode = FocusNode();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void petClassSelected(String? value) {
    firstSpeciesKey.currentState
        ?.changeSelectedItem(context.tr(AppStrings.unknown));
    secondSpeciesKey.currentState
        ?.changeSelectedItem(context.tr(AppStrings.unknown));
    if (value != null) {
      final int index =
          animalClass.indexWhere((element) => context.tr(element) == value);
      final newSpeciesList =
          speciesList[index].map((species) => species).toList();
      selectedSpeciesList = newSpeciesList;
    }
    firstSpeciesKey.currentState?.openDropDownSearch();
  }

  void registerPet() {
    if ((context.read<ImagePickerCubit>().state is ImagePickerSuccess) &&
        nameFormKey.currentState!.validate() &&
        ageFormKey.currentState!.validate() &&
        currencyCode != '-' &&
        priceFormKey.currentState!.validate() &&
        reasonFormKey.currentState!.validate()) {
      final petRegistrationReq = PetRegistrationReq(
          file: (context.read<ImagePickerCubit>().state as ImagePickerSuccess)
              .image,
          gender: selectedGender.name,
          name: petNameTextEditingController.text.trim(),
          age: petAgeTextEditingController.text.trim(),
          petClass: petClassKey.currentState!.getSelectedItem!,
          species: firstSpeciesKey.currentState!.getSelectedItem! +
                      secondSpeciesKey.currentState!.getSelectedItem! ==
                  context.tr(AppStrings.unknown)
              ? ''
              : ' & ${secondSpeciesKey.currentState!.getSelectedItem!}',
          currency: currencyCode,
          price: priceTextEditingController.text.trim(),
          reason: reasonTextEditingController.text.trim());

      context.read<RegisterPetCubit>().registerPet(petRegistrationReq);
    }
  }

  // void registerPet(BuildContext context, String uid, String ownerName,
  //     String ownerUid, String ownerEmail, String ownerPhotoUrl) async {
  //   setState(() => isLoading = true);
  //   if (image == null) {
  //     showDialog(
  //         context: context,
  //         builder: (context) {
  //           isLoading = false;
  //           if (!Platform.isIOS) {
  //             return AlertDialog(
  //               title: Text(context.tr(AppStrings.errorRegister)),
  //               content: Text(context.tr(AppStrings.selectPetImage)),
  //             );
  //           } else {
  //             return CupertinoAlertDialog(
  //               title: Text(context.tr(AppStrings.errorRegister)),
  //               content: Text(context.tr(AppStrings.selectPetImage)),
  //             );
  //           }
  //         });
  //     return;
  //   } else if (petNameTextEditingController.text.trim().isEmpty) {
  //     scrollToField(petNameFocusNode, 0);
  //   } else if (petAgeTextEditingController.text.trim().isEmpty) {
  //     scrollToField(petAgeFocusNode, 80);
  //   } else if (currencyCode == '-') {
  //     popCurrencyPicker();
  //   } else if (priceTextEditingController.text.trim().isEmpty) {
  //     scrollToField(priceFocusNode, null);
  //   } else if (descriptionTextEditingController.text.trim().isEmpty) {
  //     scrollToField(reasonFocusNode, null);
  //   } else {
  //   try {
  //     if (await checkConnectivity()) {
  //       Position currentLocation = await LocationModel.determinePosition();
  //       await FirestoreMethods.uploadRegisteredPet(
  //               _image!,
  //               uid,
  //               selectedGender.name,
  //               petNameTextEditingController.text.trim(),
  //               petAgeTextEditingController.text,
  //               selectedPetClass,
  //               getPetSpecies(),
  //               getPetPrice(),
  //               descriptionTextEditingController.text.trim(),
  //               ownerName,
  //               ownerUid,
  //               ownerEmail,
  //               currentLocation,
  //               ownerPhotoUrl)
  //           .then((value) {
  //         if (value == 'success') {
  //           Navigator.pop(context, AppStrings.petRegisteredSuccessfully.tr());
  //         } else {
  //           // showSnackBar(context, value, defaultColor: false);
  //         }
  //       });
  //     } else {
  //       // showSnackBar(context, AppStrings.noConnection.tr(),
  //       //     defaultColor: false);
  //     }
  //   } catch (e) {
  //     // showSnackBar(context, e.toString(), defaultColor: false);
  //   }
  //   }
  //   setState(() => isLoading = false);
  // }

  // String getPetSpecies() {
  // if (isHybrid == false ||
  //     secondSpeciesKey.currentState!.getSelectedItem! ==
  //         AppStrings.unknown.tr()) {
  //   final int index = selectedSpeciesList.indexWhere((element) =>
  //       element == firstSpeciesKey.currentState!.getSelectedItem!);
  //   final String firstSpeciesValue =
  //       animalMap[selectedPetClass.tr()]![1][index];
  //   return firstSpeciesValue;
  // } else if (firstSpeciesKey.currentState!.getSelectedItem! ==
  //     secondSpeciesKey.currentState!.getSelectedItem!) {
  //   final int index = _selectedSpeciesList.indexWhere((element) =>
  //       element == firstSpeciesKey.currentState!.getSelectedItem!);
  //   final String firstSpeciesValue =
  //       animalMap[selectedPetClass.tr()]![1][index];
  //   return firstSpeciesValue;
  // } else {
  //   final int firstIndex = _selectedSpeciesList.indexWhere((element) =>
  //       element == firstSpeciesKey.currentState!.getSelectedItem!);
  //   final int secondIndex = _selectedSpeciesList.indexWhere((element) =>
  //       element == secondSpeciesKey.currentState!.getSelectedItem!);
  //   final String firstSpeciesValue =
  //       animalMap[selectedPetClass.tr()]![1][firstIndex];
  //   final String secondSpeciesValue =
  //       animalMap[selectedPetClass.tr()]![1][secondIndex];
  //
  //   return '$firstSpeciesValue & $secondSpeciesValue';
  // }
  // }

  void popCurrencyPicker() {
    showCurrencyPicker(
        context: context,
        theme: CurrencyPickerThemeData(
          inputDecoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: AppColors.primary,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: AppColors.grey,
              ),
            ),
          ),
        ),
        onSelect: (Currency currency) {
          setState(() {
            currencyCode = currency.code;
          });
          FocusScope.of(context).requestFocus(priceFocusNode);
        });
  }

  // void scrollToField(FocusNode node, double? location) {
  //   setState(() {
  //     scrollController
  //         .animateTo(location ?? scrollController.position.maxScrollExtent,
  //             duration: const Duration(milliseconds: 500),
  //             curve: Curves.fastOutSlowIn)
  //         .then((_) {
  //       node.requestFocus();
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final genderToggleChildren = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.tr(AppStrings.male),
          ),
          const Icon(
            Icons.male_rounded,
            color: Colors.lightBlue,
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.tr(AppStrings.female),
          ),
          const Icon(
            Icons.female_rounded,
            color: Colors.pinkAccent,
          ),
        ],
      ),
    ];

    return AbsorbPointer(
      absorbing: isLoading,
      child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(context.tr(AppStrings.registerAdoption)),
          ),
          body: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: SingleChildScrollView(
                controller: scrollController,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          BlocBuilder<ImagePickerCubit, ImagePickerState>(
                              builder: (context, state) {
                            if (state is ImagePickerSuccess) {
                              return CircleAvatar(
                                radius: 60,
                                backgroundColor: Theme.of(context).primaryColor,
                                backgroundImage: MemoryImage(state.image),
                              );
                            }
                            return CircleAvatar(
                              radius: 60,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: const Icon(
                                Icons.pets_rounded,
                                color: Colors.white,
                                size: 50,
                              ),
                            );
                          }),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.grey[700],
                                child: const Icon(Icons.add),
                              ),
                              onTap: () {
                                context
                                    .read<ImagePickerCubit>()
                                    .pickImage(shouldCrop: true);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Platform.isIOS
                        ? CupertinoSlidingSegmentedControl(
                            padding: const EdgeInsets.all(5),
                            children: {
                              PetGender.Male: genderToggleChildren[0],
                              PetGender.Female: genderToggleChildren[1],
                            },
                            groupValue: selectedGender,
                            onValueChanged: (PetGender? value) {
                              if (value != null) {
                                setState(() {
                                  selectedGender = value;
                                });
                              }
                            },
                          )
                        : Center(
                            child: ToggleButtons(
                              direction: Axis.horizontal,
                              onPressed: (int index) {
                                setState(() {
                                  // The button that is tapped is set to true, and the others to false.
                                  for (int i = 0;
                                      i < genderToggleChildren.length;
                                      i++) {
                                    selectedGenderList[i] = i == index;
                                  }
                                });
                              },
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              selectedBorderColor: AppColors.primary,
                              selectedColor: Colors.black,
                              fillColor: Colors.transparent,
                              borderWidth: 2,
                              // color: Colors.red[400],
                              constraints: const BoxConstraints(
                                  minHeight: 40.0, minWidth: 80.0),
                              isSelected: selectedGenderList,
                              children: genderToggleChildren,
                            ),
                          ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      context.tr(AppStrings.petName),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    AdoptionFormField(
                      globalKey: nameFormKey,
                      color: AppColors.primary,
                      hintText: context.tr(AppStrings.enterPetName),
                      textInputType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      focusNode: petNameFocusNode,
                      controller: petNameTextEditingController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.tr(AppStrings.enterPetName);
                        }
                        return null;
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(petAgeFocusNode);
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      context.tr(AppStrings.petAge),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    AdoptionFormField(
                      globalKey: ageFormKey,
                      color: AppColors.primary,
                      hintText: context.tr(AppStrings.enterPetAge),
                      textInputType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: petAgeFocusNode,
                      controller: petAgeTextEditingController,
                      interactionEnabled: false,
                      isSeparatorNeeded: true,
                      maxCharacters: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.tr(AppStrings.enterPetAge);
                        }
                        return null;
                      },
                      onEditingComplete: () {
                        petClassKey.currentState?.openDropDownSearch();
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      context.tr(AppStrings.petClass),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    // TODO: Pending new package release
                    // AdaptiveDropdownSearch<T>(
                    //   popupProps: AdaptivePopupProps(
                    //       cupertinoProps: CupertinoPopupProps.bottomSheet(),
                    //       materialProps: PopupProps.dialog()),
                    // ),
                    DropdownSearch<String>(
                      key: petClassKey,
                      popupProps: PopupProps.modalBottomSheet(
                        modalBottomSheetProps: ModalBottomSheetProps(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                        ),
                        showSelectedItems: true,
                        // disabledItemFn: (String s) => s.startsWith('I'),
                      ),
                      items: (filter, infiniteScrollProps) => animalClass
                          .map((animal) => context.tr(animal))
                          .toList(),
                      // dropdownSearchDecoration: InputDecoration(
                      //   labelText: "Menu mode",
                      //   hintText: "country in menu mode",
                      // ),
                      onChanged: (value) {
                        petClassSelected(value);
                      },
                      selectedItem: animalClass
                          .map((animal) => context.tr(animal))
                          .toList()[0],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      context.tr(AppStrings.petSpecies),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    // TODO: Pending new package release
                    DropdownSearch<String>(
                      key: firstSpeciesKey,
                      popupProps: PopupProps.modalBottomSheet(
                        modalBottomSheetProps: ModalBottomSheetProps(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                        ),
                        showSelectedItems: true,
                        showSearchBox: true,
                        // disabledItemFn: (String s) => s.startsWith('I'),
                      ),
                      items: (filter, infiniteScrollProps) =>
                          selectedSpeciesList
                              .map((species) => context.tr(species))
                              .toList(),
                      // dropdownSearchDecoration: InputDecoration(
                      //   labelText: "Menu mode",
                      //   hintText: "country in menu mode",
                      // ),
                      onChanged: (value) {
                        if (value == context.tr(AppStrings.unknown)) {
                          isEnabled = false;
                          isHybrid = false;
                          secondSpeciesKey.currentState?.changeSelectedItem(
                              context.tr(AppStrings.unknown));
                        } else {
                          setState(() {
                            isEnabled = true;
                            selectedSpeciesInFirstDropdown = value;
                          });
                        }
                        if (value != context.tr(AppStrings.unknown)) {
                          popCurrencyPicker();
                        }
                      },
                      selectedItem: selectedSpeciesList
                          .map((animal) => context.tr(animal))
                          .toList()[0],
                    ),
                    const SizedBox(height: 10.0),
                    ListTile(
                      title: Text(
                        context.tr(AppStrings.hybrid),
                      ),
                      leading: Checkbox(
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: isEnabled
                            ? (bool? value) {
                                if (value != null) {
                                  if (value == false) {
                                    secondSpeciesKey.currentState!
                                        .changeSelectedItem(
                                            context.tr(AppStrings.unknown));
                                  }
                                  setState(() {
                                    isHybrid = value;
                                  });
                                }
                              }
                            : null,
                        value: isHybrid,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    // TODO: Pending new package release
                    DropdownSearch<String>(
                      key: secondSpeciesKey,
                      enabled: isHybrid,
                      popupProps: PopupProps.modalBottomSheet(
                        modalBottomSheetProps: ModalBottomSheetProps(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                        ),
                        showSelectedItems: true,
                        showSearchBox: true,
                        // disabledItemFn: (String s) => s.startsWith(_firstOption),
                      ),
                      // TODO: Filter unknown item and change logic in register pet function
                      items: (filter, infiniteScrollProps) =>
                          selectedSpeciesList
                              .where((species) =>
                                  context.tr(species) !=
                                  context
                                      .tr(selectedSpeciesInFirstDropdown ?? ''))
                              .map((species) => context.tr(species))
                              .toList(),
                      // dropdownSearchDecoration: InputDecoration(
                      //   labelText: "Menu mode",
                      //   hintText: "country in menu mode",
                      // ),
                      onChanged: (value) {
                        if (value != null) {
                          if (value == context.tr(AppStrings.unknown)) {
                            setState(() {
                              isHybrid = false;
                            });
                          }
                        }
                      },
                      selectedItem: selectedSpeciesList
                          .map((species) => context.tr(species))
                          .toList()[0],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      context.tr(AppStrings.price),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 100.0,
                          height: 50.0,
                          child: ElevatedButton(
                              onPressed: () {
                                popCurrencyPicker();
                              },
                              child: Text(
                                currencyCode,
                                style: const TextStyle(color: Colors.white),
                              )),
                        ),
                        const SizedBox(
                          width: 25.0,
                        ),
                        Expanded(
                          child: AdoptionFormField(
                            globalKey: priceFormKey,
                            color: AppColors.primary,
                            isTextCentered: true,
                            isSeparatorNeeded: true,
                            focusNode: priceFocusNode,
                            controller: priceTextEditingController,
                            textInputType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            hintText: context.tr(AppStrings.enterPrice),
                            interactionEnabled: false,
                            maxCharacters: 9,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return context.tr(AppStrings.enterPrice);
                              }
                              return null;
                            },
                            onEditingComplete: () {
                              FocusScope.of(context)
                                  .requestFocus(reasonFocusNode);
                            },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      context.tr(AppStrings.reasonForRehoming),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    AdoptionFormField(
                      globalKey: reasonFormKey,
                      color: AppColors.primary,
                      maxLines: 5,
                      focusNode: reasonFocusNode,
                      controller: reasonTextEditingController,
                      textInputType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      hintText: context.tr(AppStrings.enterReason),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.tr(AppStrings.enterReason);
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    SafeArea(
                      child: Center(
                        child: SizedBox(
                          height: 50,
                          width: 170,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // registerPet(context, user.uid,
                                //   user.username, user.uid, user.email, user.photoUrl)
                              },
                              icon: isLoading
                                  ? const SpinKitCircle(
                                      color: Colors.white,
                                      size: 24.0,
                                    )
                                  : Icon(
                                      Platform.isIOS
                                          ? Icons.arrow_forward_ios
                                          : Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                              label: Text(
                                context.tr(AppStrings.registerPet),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          )),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pawsome/core/theme/app_colors.dart';
import 'package:pawsome/domain/pet/entity/pet.dart';
import 'package:pawsome/presentation/adoption/bloc/adoption_cubit.dart';
import 'package:pawsome/presentation/adoption/bloc/pet_list_view_selection_cubit.dart';
import 'package:pawsome/presentation/adoption/widgets/pet_list_view.dart';
import 'package:pawsome/presentation/adoption/widgets/search_textfield.dart';

import '../../../core/theme/app_strings.dart';
import '../../../service_locator.dart';
import '../widgets/adoption_card.dart';

class AdoptionScreen extends StatefulWidget {
  const AdoptionScreen({super.key});

  @override
  State<AdoptionScreen> createState() => _AdoptionScreenState();
}

class _AdoptionScreenState extends State<AdoptionScreen>
    with SingleTickerProviderStateMixin {
  final ScrollPhysics physics = const BouncingScrollPhysics();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // final Geoflutterfire _geo = Geoflutterfire();

  var _collectionReference;

  List<DocumentSnapshot>? adoptionCardList;

  late Stream<List<DocumentSnapshot<Map<String, dynamic>>>> _stream;

  // late GeoFirePoint _center;
  late ScrollController scrollController;

  // Animated Icon
  late AnimationController animatedIconController;

  String? selectedValue;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    animatedIconController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    scrollController = ScrollController();
    // _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    animatedIconController.dispose();
    scrollController.dispose();
    // _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  Future<void> _refresh() async {
    // LocationModel.origin = await LocationModel.determinePosition();
    // _scrollController.addListener(_scrollListener);
    setState(() {});
  }

  void sortAdoptionList() {
    // adoptionCardList!.sort((a, b) {
    //   return LocationModel.getDistanceBetween(
    //       (a['location']['geopoint'] as GeoPoint).latitude,
    //       (a['location']['geopoint'] as GeoPoint).longitude)
    //       .compareTo(LocationModel.getDistanceBetween(
    //       (b['location']['geopoint'] as GeoPoint).latitude,
    //       (b['location']['geopoint'] as GeoPoint).longitude));
    // });
  }

  // void _scrollListener() {
  //   if (adoptionCardList != null) {
  //     if (adoptionCardList!.length ==
  //         Provider.of<PetData>(context, listen: false).radius) {
  //       if (_scrollController.position.pixels >
  //           _scrollController.position.maxScrollExtent - 100) {
  //         _scrollController.removeListener(_scrollListener);
  //         // Provider.of<PetData>(context, listen: false).setShouldLoadingCard =
  //         //     true;
  //       }
  //     }
  //   }
  // }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    // final result = await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const AddPetScreen()),
    // );

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    // if (result != null) {
    //   // ScaffoldMessenger.of(context)
    //   _scaffoldKey.currentState!
    //     ..removeCurrentSnackBar()
    //     ..showSnackBar(SnackBar(
    //       content: Text(
    //         '$result',
    //         style: const TextStyle(color: Colors.white),
    //       ),
    //       backgroundColor: Theme.of(context).primaryColor,
    //       animation: null,
    //     ));
    // }
  }

  @override
  Widget build(BuildContext context) {
    // final PetData petData = Provider.of<PetData>(context);
    // final LanguageData languageData = Provider.of<LanguageData>(context);

    // if (petData.controller == null) {
    //   petData.controller = AnimationController(
    //       vsync: this, duration: const Duration(milliseconds: 500));
    //   // petData.controller = _controller;
    // } else {
    //   _controller = petData.controller!;
    // }

    return Scaffold(
      extendBodyBehindAppBar: true,
      // backgroundColor: Colors.white.withAlpha(700),

      key: _scaffoldKey,
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(0),
      //   // Set height to 0 to remove the space
      //   child: AppBar(
      //     backgroundColor: Colors.transparent,
      //     elevation: 0,
      //   ),
      // ),
      // appBar: CustomAppBar(
      //   appBar: AppBar(
      //     centerTitle: true,
      //     title: Text(
      //       AppStrings.adoption.tr(),
      //     ),
      //     actions: [
      //       Padding(
      //         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      //         child: DropdownButtonHideUnderline(
      //           child: DropdownButton2(
      //             isExpanded: true,
      //             hint: Center(
      //               child: Text('',
      //                 // '${petData.radius} ${AppStrings.km.tr()}',
      //                 style: TextStyle(
      //                     color: Colors.white,
      //                     // fontSize:
      //                     // (languageData.languageType == Language.english)
      //                     //     ? 14
      //                     //     : 12
      //                 ),
      //               ),
      //             ),
      //             items: distanceItem
      //                 .map((item) => DropdownMenuItem<String>(
      //               value: item,
      //               child: Text(
      //                 item,
      //                 style: const TextStyle(
      //                   fontSize: 14,
      //                   fontWeight: FontWeight.bold,
      //                   color: Colors.white,
      //                 ),
      //                 overflow: TextOverflow.ellipsis,
      //               ),
      //             ))
      //                 .toList(),
      //             value: selectedValue,
      //             onChanged: (value) {
      //               if (value != null) {
      //                 // petData.setRadius = int.parse(value as String);
      //               }
      //             },
      //             // icon: const Icon(
      //             //   Icons.arrow_forward_ios_outlined,
      //             // ),
      //             // iconSize: 14,
      //             // iconEnabledColor: Colors.yellow,
      //             // iconDisabledColor: Colors.grey,
      //             // buttonHeight: 50,
      //             // buttonWidth: 80,
      //             // buttonPadding: const EdgeInsets.only(left: 5, right: 5),
      //             // buttonDecoration: BoxDecoration(
      //             //   borderRadius: BorderRadius.circular(14),
      //             //   border: Border.all(
      //             //     color: Colors.black26,
      //             //   ),
      //             //   color: Theme.of(context).primaryColor,
      //             // ),
      //             // buttonElevation: 2,
      //             // itemHeight: 40,
      //             // itemPadding: const EdgeInsets.only(left: 14, right: 14),
      //             // dropdownMaxHeight: 200,
      //             // dropdownWidth: 120,
      //             // dropdownPadding: null,
      //             // dropdownDecoration: BoxDecoration(
      //             //   borderRadius: BorderRadius.circular(14),
      //             //   color: Theme.of(context).primaryColor,
      //             // ),
      //             // dropdownElevation: 8,
      //             // scrollbarRadius: const Radius.circular(40),
      //             // scrollbarThickness: 6,
      //             // scrollbarAlwaysShow: true,
      //             // offset: const Offset(-20, 0),
      //           ),
      //         ),
      //       ),
      //       IconButton(
      //         onPressed: () {
      //           _navigateAndDisplaySelection(context);
      //           // Navigator.of(context).push(MaterialPageRoute(
      //           //     builder: (context) => const AddPetScreen()));
      //         },
      //         icon: const Icon(
      //           Icons.pets_rounded,
      //           // color: Colors.black,
      //         ),
      //       )
      //     ],
      //   ),
      //   onTap: () {
      //     if (adoptionCardList != null) {
      //       _scrollController.animateTo(0,
      //           duration: const Duration(milliseconds: 300),
      //           curve: Curves.easeIn);
      //     }
      //   },
      // ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<PetListViewSelectionCubit>(
            create: (context) => sl<PetListViewSelectionCubit>(),
          ),
          BlocProvider<AdoptionCubit>(
            create: (context) => sl<AdoptionCubit>()..adoptionStream(),
          ),
        ],
        child: SafeArea(
          child: RefreshIndicator(
            color: Theme.of(context).primaryColor,
            edgeOffset: 90,
            onRefresh: _refresh,
            child: SingleChildScrollView(
              controller: scrollController,
              physics: physics,
              child: Column(
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: SearchTextField(),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      // margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      height: 60,
                      child: Row(
                        children: [
                          BlocBuilder<PetListViewSelectionCubit, int?>(
                            builder: (context, selectedIndex) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: selectedIndex != null ? 20 : 0,
                                child: GestureDetector(
                                  child: AnimatedIcon(
                                      color: selectedIndex != null
                                          ? Colors.red
                                          : Colors.transparent,
                                      icon: AnimatedIcons.menu_close,
                                      progress: animatedIconController),
                                  onTap: () {
                                    HapticFeedback.mediumImpact();
                                    animatedIconController.reverse();
                                    context
                                        .read<PetListViewSelectionCubit>()
                                        .selectPet(null);
                                  },
                                ),
                              );
                            },
                          ),
                          Flexible(
                            child: PetListView(
                              triggerAnimation: () {
                                // petData.setAnimatedIconColor = Colors.red;
                                animatedIconController.forward();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.grey[400],
                  ),
                  BlocBuilder<AdoptionCubit, AdoptionState>(
                    builder: (context, state) {
                      print(state);
                      if (state is AdoptionLoading) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
                            child: Container(
                                padding: const EdgeInsets.all(10.0),
                                height: 120.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                                child: Center(
                                  child: SpinKitThreeBounce(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )),
                          ),
                        );
                      } else if (state is AdoptionError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
                            child: Text(
                              'Oops, seems like an error has occurred.',
                              style: TextStyle(color: AppColors.black),
                            ),
                          ),
                        );
                      } else if (state is AdoptionSuccess) {
                        // sortAdoptionList();
                        // for (DocumentSnapshot document in adoptionCardList!) {
                        //   print(document.data());
                        // }
                        return ListView.builder(
                          padding: const EdgeInsets.all(0),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.petList.length,
                          scrollDirection: Axis.vertical,
                          cacheExtent: 9999,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return AdoptionCard(
                              pet: state.petList[index],
                              index: index,
                            );
                          },
                        );
                      } else if (state is AdoptionEmpty) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                          child: Center(
                            child: Text(
                              context.tr(AppStrings.noPetsNearby),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  // petData.shouldShowLoadingCard
                  //     ? Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 25, vertical: 10),
                  //   child: petData.shouldShowLoadingCard
                  //       ? Container(
                  //       padding: const EdgeInsets.all(10.0),
                  //       height: 120,
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(15.0),
                  //         color:
                  //         Theme.of(context).colorScheme.background,
                  //       ),
                  //       child: Center(
                  //         child: SpinKitThreeBounce(
                  //           color: Theme.of(context).primaryColor,
                  //         ),
                  //       ))
                  //       : Container(),
                  // )
                  //     : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// margin: EdgeInsets.only(
//     top: MediaQuery.of(context).size.height * 0.13),
// decoration: BoxDecoration(
//   borderRadius: BorderRadius.circular(20.0),
//   color: Theme.of(context).colorScheme.secondaryContainer,
// ),

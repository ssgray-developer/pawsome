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
import 'package:pawsome/core/theme/app_values.dart';
import 'package:pawsome/presentation/bloc/image_picker/image_picker_cubit.dart';
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
  final List<bool> selectedGenderList = [true, false];
  PetGender selectedGender = PetGender.Male;
  String currencyCode = '-';
  Uint8List? image;
  late Map<String, List<List<String>>> animalMap;
  List<String> selectedSpeciesList = [
    AppStrings.unknown,
    AppStrings.africanGrayParrot,
    AppStrings.amazonParrot,
    AppStrings.blueHeadedParrot,
    AppStrings.bronzeWingedParrot,
    AppStrings.budgerigarBudgieParakeet,
    AppStrings.canary,
    AppStrings.cockatiel,
    AppStrings.cockatoo,
    AppStrings.dovePigeon,
    AppStrings.duskyPionus,
    AppStrings.eclectusParrot,
    AppStrings.finch,
    AppStrings.greenCheekedParakeet,
    AppStrings.hyacinthMacaw,
    AppStrings.loveBird,
    AppStrings.macaw,
    AppStrings.monkParakeet,
    AppStrings.redBilledPionus,
    AppStrings.scalyHeadedPionus,
    AppStrings.senegalParrot,
    AppStrings.sunParakeet,
    AppStrings.roseRingedParakeet,
    AppStrings.whiteCrownedPionus,
    AppStrings.zebraFinch,
  ];

  final animalClass = [
    AppStrings.bird,
    AppStrings.cat,
    AppStrings.dog,
    AppStrings.ferret,
    AppStrings.fish,
    AppStrings.guineaPig,
    AppStrings.horse,
    AppStrings.iguana,
    AppStrings.mouseRat,
    AppStrings.otter,
    AppStrings.rabbit,
    AppStrings.tortoise,
  ];

  String selectedPetClass = AppStrings.bird;

  late GlobalKey<DropdownSearchState<String>> firstSpeciesKey;
  late GlobalKey<DropdownSearchState<String>> secondSpeciesKey;

  late ScrollController scrollController;

  late FocusNode petNameFocusNode;
  late FocusNode petAgeFocusNode;
  late FocusNode descriptionFocusNode;
  late FocusNode priceFocusNode;

  late TextEditingController petNameTextEditingController;
  late TextEditingController petAgeTextEditingController;
  late TextEditingController descriptionTextEditingController;
  late TextEditingController priceTextEditingController;

  @override
  void initState() {
    super.initState();
    firstSpeciesKey = GlobalKey<DropdownSearchState<String>>();
    secondSpeciesKey = GlobalKey<DropdownSearchState<String>>();

    scrollController = ScrollController();

    petNameTextEditingController = TextEditingController();
    petAgeTextEditingController = TextEditingController();
    descriptionTextEditingController = TextEditingController();
    priceTextEditingController = TextEditingController();

    petNameFocusNode = FocusNode();
    petAgeFocusNode = FocusNode();
    descriptionFocusNode = FocusNode();
    priceFocusNode = FocusNode();

    // petNameFocusNode.addListener(() => setState(() {}));
    // petAgeFocusNode.addListener(() => setState(() {}));
    // descriptionFocusNode.addListener(() => setState(() {}));
    // priceFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void petClassSelected(String? value) {
    // _firstSpeciesKey.currentState!.changeSelectedItem(AppStrings.unknown.tr());
    // _secondSpeciesKey.currentState!.changeSelectedItem(AppStrings.unknown.tr());
    // if (value != null) {
    //   final int index = animalClass.indexWhere((element) => element == value);
    //   selectedPetClass = animalValueClass[index];
    //   _selectedSpeciesList = animalMap[value]![0];
    //   // setState(() {
    //   // _selectedPetClass = value;
    //   // _selectedPetClass = animalValueClass[index];
    //   // _selectedSpeciesList = animalMap[value]![0];
    //   // });
    // }
  }

  void registerPet(BuildContext context, String uid, String ownerName,
      String ownerUid, String ownerEmail, String ownerPhotoUrl) async {
    setState(() => isLoading = true);
    if (image == null) {
      showDialog(
          context: context,
          builder: (context) {
            isLoading = false;
            if (!Platform.isIOS) {
              return AlertDialog(
                title: Text(context.tr(AppStrings.errorRegister)),
                content: Text(context.tr(AppStrings.selectPetImage)),
              );
            } else {
              return CupertinoAlertDialog(
                title: Text(context.tr(AppStrings.errorRegister)),
                content: Text(context.tr(AppStrings.selectPetImage)),
              );
            }
          });
      return;
    } else if (petNameTextEditingController.text.trim().isEmpty) {
      scrollToField(petNameFocusNode, 0);
    } else if (petAgeTextEditingController.text.trim().isEmpty) {
      scrollToField(petAgeFocusNode, 80);
    } else if (currencyCode == '-') {
      popCurrencyPicker();
    } else if (priceTextEditingController.text.trim().isEmpty) {
      scrollToField(priceFocusNode, null);
    } else if (descriptionTextEditingController.text.trim().isEmpty) {
      scrollToField(descriptionFocusNode, null);
    } else {
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
    }
    setState(() => isLoading = false);
  }

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

  String getPetPrice() {
    return '$currencyCode ${priceTextEditingController.text}';
  }

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
        });
  }

  void scrollToField(FocusNode node, double? location) {
    setState(() {
      scrollController
          .animateTo(location ?? scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn)
          .then((_) {
        node.requestFocus();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // User user = Provider.of<UserViewModel>(context).getUser;

    List<String> birdSpecies = [
      AppStrings.unknown.tr(),
      AppStrings.africanGrayParrot.tr(),
      AppStrings.amazonParrot.tr(),
      AppStrings.blueHeadedParrot.tr(),
      AppStrings.bronzeWingedParrot.tr(),
      AppStrings.budgerigarBudgieParakeet.tr(),
      AppStrings.canary.tr(),
      AppStrings.cockatiel.tr(),
      AppStrings.cockatoo.tr(),
      AppStrings.dovePigeon.tr(),
      AppStrings.duskyPionus.tr(),
      AppStrings.eclectusParrot.tr(),
      AppStrings.finch.tr(),
      AppStrings.greenCheekedParakeet.tr(),
      AppStrings.hyacinthMacaw.tr(),
      AppStrings.loveBird.tr(),
      AppStrings.macaw.tr(),
      AppStrings.monkParakeet.tr(),
      AppStrings.redBilledPionus.tr(),
      AppStrings.scalyHeadedPionus.tr(),
      AppStrings.senegalParrot.tr(),
      AppStrings.sunParakeet.tr(),
      AppStrings.roseRingedParakeet.tr(),
      AppStrings.whiteCrownedPionus.tr(),
      AppStrings.zebraFinch.tr(),
    ];

    List<String> catSpecies = [
      AppStrings.unknown.tr(),
      AppStrings.abyssinian.tr(),
      AppStrings.americanBobtail.tr(),
      AppStrings.americanCurl.tr(),
      AppStrings.americanShorthair.tr(),
      AppStrings.americanWirehair.tr(),
      AppStrings.bengalCat.tr(),
      AppStrings.birman.tr(),
      AppStrings.balineseCat.tr(),
      AppStrings.bombayCat.tr(),
      AppStrings.britishLonghair.tr(),
      AppStrings.britishShorthair.tr(),
      AppStrings.burmeseCat.tr(),
      AppStrings.burmilla.tr(),
      AppStrings.caracal.tr(),
      AppStrings.chartreux.tr(),
      AppStrings.cornishRex.tr(),
      AppStrings.cymric.tr(),
      AppStrings.donskoy.tr(),
      AppStrings.europeanShorthair.tr(),
      AppStrings.exoticShorthair.tr(),
      AppStrings.havanaBrown.tr(),
      AppStrings.himalayanCat.tr(),
      AppStrings.korat.tr(),
      AppStrings.laperm.tr(),
      AppStrings.lykoi.tr(),
      AppStrings.maineCoon.tr(),
      AppStrings.manxCat.tr(),
      AppStrings.munchkinCat.tr(),
      AppStrings.nebelung.tr(),
      AppStrings.norwegianForestCat.tr(),
      AppStrings.ocicat.tr(),
      AppStrings.orientalLonghair.tr(),
      AppStrings.orientalShorthair.tr(),
      AppStrings.persianCat.tr(),
      AppStrings.peterbald.tr(),
      AppStrings.ragamuffin.tr(),
      AppStrings.ragdoll.tr(),
      AppStrings.russianBlue.tr(),
      AppStrings.savannahCat.tr(),
      AppStrings.scottishFold.tr(),
      AppStrings.selkirkRex.tr(),
      AppStrings.siameseCat.tr(),
      AppStrings.siberianCat.tr(),
      AppStrings.singapuraCat.tr(),
      AppStrings.somaliCat.tr(),
      AppStrings.sphynxCat.tr(),
      AppStrings.thaiCat.tr(),
      AppStrings.tonkineseCat.tr(),
      AppStrings.toyger.tr(),
      AppStrings.turkishAngora.tr(),
      AppStrings.vanCat.tr(),
    ];

    List<String> dogSpecies = [
      AppStrings.unknown.tr(),
      AppStrings.affenpinscher.tr(),
      AppStrings.afghanHound.tr(),
      AppStrings.airedaleTerrier.tr(),
      AppStrings.alaskanMalamute.tr(),
      AppStrings.americanBulldog.tr(),
      AppStrings.americanEskimoDog.tr(),
      AppStrings.americanStaffordshireTerrier.tr(),
      AppStrings.australianCattleDog.tr(),
      AppStrings.australianShepherd.tr(),
      AppStrings.basenji.tr(),
      AppStrings.bassetHound.tr(),
      AppStrings.beagle.tr(),
      AppStrings.beardedCollie.tr(),
      AppStrings.belgianShepherd.tr(),
      AppStrings.berneseMountainDog.tr(),
      AppStrings.bichonFrise.tr(),
      AppStrings.borderCollie.tr(),
      AppStrings.borderTerrier.tr(),
      AppStrings.bostonTerrier.tr(),
      AppStrings.boxer.tr(),
      AppStrings.brittany.tr(),
      AppStrings.brusselsGriffon.tr(),
      AppStrings.bulldog.tr(),
      AppStrings.bullTerrier.tr(),
      AppStrings.cairnTerrier.tr(),
      AppStrings.cavalierKingCharlesSpaniel.tr(),
      AppStrings.chihuahua.tr(),
      AppStrings.chowChow.tr(),
      AppStrings.dachshund.tr(),
      AppStrings.dalmation.tr(),
      AppStrings.dobermann.tr(),
      AppStrings.englishCockerSpaniel.tr(),
      AppStrings.frenchBulldog.tr(),
      AppStrings.germanShepherd.tr(),
      AppStrings.greatDane.tr(),
      AppStrings.goldenRetriever.tr(),
      AppStrings.irishSetter.tr(),
      AppStrings.labradorRetriever.tr(),
      AppStrings.malteseDog.tr(),
      AppStrings.newfoundlandDog.tr(),
      AppStrings.papillon.tr(),
      AppStrings.pembrokeWelshCorgi.tr(),
      AppStrings.pomeranian.tr(),
      AppStrings.poodle.tr(),
      AppStrings.pug.tr(),
      AppStrings.rottweiler.tr(),
      AppStrings.shetlandSheepdog.tr(),
      AppStrings.shihTzu.tr(),
      AppStrings.siberianHusky.tr(),
      AppStrings.softcoatedWheatenTerrier.tr(),
      AppStrings.yorkshireTerrier.tr(),
    ];

    List<String> ferretSpecies = [
      AppStrings.unknown.tr(),
      AppStrings.albinoFerret.tr(),
      AppStrings.blazeFerret.tr(),
      AppStrings.champagneFerret.tr(),
      AppStrings.chocolateFerret.tr(),
      AppStrings.cinnamonFerret.tr(),
      AppStrings.dalmatianFerret.tr(),
      AppStrings.pandaFerret.tr(),
      AppStrings.siameseFerret.tr(),
      AppStrings.silverFerret.tr(),
    ];

    List<String> fishSpecies = [
      AppStrings.unknown.tr(),
      AppStrings.africanCichlid.tr(),
      AppStrings.angelfish.tr(),
      AppStrings.asianStoneCatfish.tr(),
      AppStrings.bichir.tr(),
      AppStrings.bloodfinTetra.tr(),
      AppStrings.bloodParrotCichlid.tr(),
      AppStrings.cardinalTetra.tr(),
      AppStrings.cherryBarb.tr(),
      AppStrings.cherryShrimp.tr(),
      AppStrings.clownLoach.tr(),
      AppStrings.convictCichlid.tr(),
      AppStrings.danioMargaritatus.tr(),
      AppStrings.diamondTetra.tr(),
      AppStrings.dwarfGourami.tr(),
      AppStrings.firemouthCichlid.tr(),
      AppStrings.glassCatfish.tr(),
      AppStrings.goldBarb.tr(),
      AppStrings.goldfish.tr(),
      AppStrings.greenTexasCichlid.tr(),
      AppStrings.guppy.tr(),
      AppStrings.harlequinRasboras.tr(),
      AppStrings.jackDempsey.tr(),
      AppStrings.killifish.tr(),
      AppStrings.kuhliLoach.tr(),
      AppStrings.marbledHatchetfish.tr(),
      AppStrings.mollies.tr(),
      AppStrings.neonTetra.tr(),
      AppStrings.odessaBarb.tr(),
      AppStrings.oscarCichlid.tr(),
      AppStrings.otocinclus.tr(),
      AppStrings.pearlGourami.tr(),
      AppStrings.pictusCatfish.tr(),
      AppStrings.platy.tr(),
      AppStrings.rainbowfish.tr(),
      AppStrings.rainbowShark.tr(),
      AppStrings.ramCichlid.tr(),
      AppStrings.raphaelCatfish.tr(),
      AppStrings.redeyeTetra.tr(),
      AppStrings.rosyBarb.tr(),
      AppStrings.siameseFightingFish.tr(),
      AppStrings.swordTail.tr(),
      AppStrings.tigerBarb.tr(),
      AppStrings.upsideDownCatfish.tr(),
      AppStrings.whiteCloudMountainMinnow.tr(),
      AppStrings.zebrafish.tr(),
    ];

    List<String> horseSpecies = [
      AppStrings.unknown.tr(),
      AppStrings.akhalTeke.tr(),
      AppStrings.americanPaintHorse.tr(),
      AppStrings.americanQuarterHorse.tr(),
      AppStrings.americanSaddlebred.tr(),
      AppStrings.andalusianHorse.tr(),
      AppStrings.appaloosa.tr(),
      AppStrings.arabianHorse.tr(),
      AppStrings.ardennais.tr(),
      AppStrings.belgianHorse.tr(),
      AppStrings.belgianWarmblood.tr(),
      AppStrings.blackForestHorse.tr(),
      AppStrings.bretonHorse.tr(),
      AppStrings.clydesdaleHorse.tr(),
      AppStrings.criolloHorse.tr(),
      AppStrings.curlyHorse.tr(),
      AppStrings.dutchWarmblood.tr(),
      AppStrings.falabella.tr(),
      AppStrings.fellPony.tr(),
      AppStrings.fjordHorse.tr(),
      AppStrings.friesianHorse.tr(),
      AppStrings.gypsyHorse.tr(),
      AppStrings.haflinger.tr(),
      AppStrings.hanoverianHorse.tr(),
      AppStrings.holsteiner.tr(),
      AppStrings.huculPony.tr(),
      AppStrings.icelandicHorse.tr(),
      AppStrings.irishSportHorse.tr(),
      AppStrings.knabstrupper.tr(),
      AppStrings.konik.tr(),
      AppStrings.lipizzan.tr(),
      AppStrings.lusitano.tr(),
      AppStrings.mangalargaMarchador.tr(),
      AppStrings.marwariHorse.tr(),
      AppStrings.missouriFoxTrotter.tr(),
      AppStrings.mongolianHorse.tr(),
      AppStrings.morganHorse.tr(),
      AppStrings.mustang.tr(),
      AppStrings.noriker.tr(),
      AppStrings.pasoFino.tr(),
      AppStrings.percheron.tr(),
      AppStrings.peruvianPaso.tr(),
      AppStrings.shetlandPony.tr(),
      AppStrings.shireHorse.tr(),
      AppStrings.silesianHorse.tr(),
      AppStrings.standardbred.tr(),
      AppStrings.tennesseeWalkingHorse.tr(),
      AppStrings.trakehner.tr(),
    ];

    List<String> guineaPigSpecies = [
      AppStrings.unknown.tr(),
      AppStrings.abyssinianGuineaPig.tr(),
      AppStrings.americanGuineaPig.tr(),
      AppStrings.peruvianGuineaPig.tr(),
      AppStrings.rexGuineaPig.tr(),
      AppStrings.sheltieSilkieGuineaPig.tr(),
      AppStrings.skinnyGuineaPig.tr(),
      AppStrings.teddyGuineaPig.tr(),
      AppStrings.texelGuineaPig.tr(),
      AppStrings.whiteCrestedGuineaPig.tr(),
    ];

    List<String> iguanaSpecies = [
      AppStrings.unknown.tr(),
      AppStrings.angelIslandChuckwalla.tr(),
      AppStrings.blueIguana.tr(),
      AppStrings.brachylophusBulabula.tr(),
      AppStrings.brachylophusFasciatus.tr(),
      AppStrings.commonChuckwalla.tr(),
      AppStrings.ctenosauraBakeri.tr(),
      AppStrings.ctenosauraFlavidorsalis.tr(),
      AppStrings.ctenosauraPalearis.tr(),
      AppStrings.ctenosauraPectinata.tr(),
      AppStrings.ctenosauraQuinquecarinata.tr(),
      AppStrings.cycluraNubila.tr(),
      AppStrings.desertIguana.tr(),
      AppStrings.fijiCrestedIguana.tr(),
      AppStrings.greenIguana.tr(),
      AppStrings.lesserAntilleanIguana.tr(),
      AppStrings.northernBahamianRockIguana.tr(),
      AppStrings.rhinocerosIguana.tr(),
      AppStrings.yucatanSpinyTailedIguana.tr(),
    ];

    List<String> mouseRatSpecies = [
      AppStrings.unknown.tr(),
      AppStrings.africanPygmyMouse.tr(),
      AppStrings.blackRat.tr(),
      AppStrings.brownRat.tr(),
      AppStrings.cairoSpinyMouse.tr(),
      AppStrings.ceylonSpinyMouse.tr(),
      AppStrings.creteSpinyMouse.tr(),
      AppStrings.gairdnersShrewmouse.tr(),
      AppStrings.gambianPouchedRat.tr(),
      AppStrings.houseMouse.tr(),
      AppStrings.macedonianMouse.tr(),
      AppStrings.mattheysMouse.tr(),
      AppStrings.mongolianGerbil.tr(),
      AppStrings.natalMultimammateMouse.tr(),
      AppStrings.summitRat.tr(),
      AppStrings.temmincksMouse.tr(),
      AppStrings.turkestanRat.tr(),
    ];

    List<String> otterSpecies = [
      AppStrings.unknown.tr(),
      AppStrings.africanClawlessOtter.tr(),
      AppStrings.americanMink.tr(),
      AppStrings.asianSmallClawedOtter.tr(),
      AppStrings.eurasianOtter.tr(),
      AppStrings.giantOtter.tr(),
      AppStrings.hairyNosedOtter.tr(),
      AppStrings.marineOtter.tr(),
      AppStrings.neotropicalOtter.tr(),
      AppStrings.northAmericanRiverOtter.tr(),
      AppStrings.seaOtter.tr(),
      AppStrings.smoothCoatedOtter.tr(),
      AppStrings.southernRiverOtter.tr(),
      AppStrings.spottedNeckedOtter.tr(),
    ];

    List<String> rabbitSpecies = [
      AppStrings.unknown.tr(),
      AppStrings.alaskaRabbit.tr(),
      AppStrings.americanFuzzyLop.tr(),
      AppStrings.americanRabbit.tr(),
      AppStrings.annamiteStripedRabbit.tr(),
      AppStrings.appalachianCottontail.tr(),
      AppStrings.brushRabbit.tr(),
      AppStrings.bunyoroRabbit.tr(),
      AppStrings.cashmereLop.tr(),
      AppStrings.checkeredGiantRabbit.tr(),
      AppStrings.commonTapeti.tr(),
      AppStrings.deilenaar.tr(),
      AppStrings.desertCottontail.tr(),
      AppStrings.dicesCottontail.tr(),
      AppStrings.easternCottontail.tr(),
      AppStrings.europeanRabbit.tr(),
      AppStrings.flemishGiantRabbit.tr(),
      AppStrings.floridaWhiteRabbit.tr(),
      AppStrings.hollandLop.tr(),
      AppStrings.jerseyWooly.tr(),
      AppStrings.marshRabbit.tr(),
      AppStrings.mexicanCottontail.tr(),
      AppStrings.miniLop.tr(),
      AppStrings.mountainCottontail.tr(),
      AppStrings.netherlandDwarfRabbit.tr(),
      AppStrings.newEnglandCottontail.tr(),
      AppStrings.omiltemeCottontail.tr(),
      AppStrings.polishRabbit.tr(),
      AppStrings.pygmyRabbit.tr(),
      AppStrings.riverineRabbit.tr(),
      AppStrings.sumatranStripedRabbit.tr(),
      AppStrings.swampRabbit.tr(),
      AppStrings.tresMariasCottontail.tr(),
      AppStrings.volcanoRabbit.tr(),
    ];

    List<String> tortoiseSpecies = [
      AppStrings.unknown.tr(),
      AppStrings.africanSpurredTortoise.tr(),
      AppStrings.aldabraGiantTortoise.tr(),
      AppStrings.asianForestTortoise.tr(),
      AppStrings.bellsHingeBackTortoise.tr(),
      AppStrings.bolsonTortoise.tr(),
      AppStrings.burmeseStarTortoise.tr(),
      AppStrings.chacoTortoise.tr(),
      AppStrings.egyptianTortoise.tr(),
      AppStrings.greekTortoise.tr(),
      AppStrings.hermannsTortoise.tr(),
      AppStrings.homesHingeBackTortoise.tr(),
      AppStrings.homopusAreolatus.tr(),
      AppStrings.homopusFemoralis.tr(),
      AppStrings.impressedTortoise.tr(),
      AppStrings.indianStarTortoise.tr(),
      AppStrings.leopardTortoise.tr(),
      AppStrings.marginatedTortoise.tr(),
      AppStrings.pancakeTortoise.tr(),
      AppStrings.ploughshareTortoise.tr(),
      AppStrings.radiatedTortoise.tr(),
      AppStrings.redFootedTortoise.tr(),
      AppStrings.russianTortoise.tr(),
      AppStrings.speckledCapeTortoise.tr(),
      AppStrings.spiderTortoise.tr(),
      AppStrings.texasTortoise.tr(),
      AppStrings.yellowFootedTortoise.tr(),
    ];

    // animalMap = {
    //   AppStrings.bird.tr(): [birdSpecies, birdValueSpecies],
    //   AppStrings.cat.tr(): [catSpecies, catValueSpecies],
    //   AppStrings.dog.tr(): [dogSpecies, dogValueSpecies],
    //   AppStrings.ferret.tr(): [ferretSpecies, ferretValueSpecies],
    //   AppStrings.fish.tr(): [fishSpecies, fishValueSpecies],
    //   AppStrings.guineaPig.tr(): [guineaPigSpecies, guineaPigValueSpecies],
    //   AppStrings.horse.tr(): [horseSpecies, horseValueSpecies],
    //   AppStrings.iguana.tr(): [iguanaSpecies, iguanaValueSpecies],
    //   AppStrings.mouseRat.tr(): [mouseRatSpecies, mouseRatValueSpecies],
    //   AppStrings.otter.tr(): [otterSpecies, otterValueSpecies],
    //   AppStrings.rabbit.tr(): [rabbitSpecies, rabbitValueSpecies],
    //   AppStrings.tortoise.tr(): [tortoiseSpecies, tortoiseValueSpecies],
    // };

    // _selectedSpeciesList = birdSpecies;
    // print('changed');

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
                        color: AppColors.primary,
                        hintText: context.tr(AppStrings.enterPetName),
                        textInputType: TextInputType.name,
                        focusNode: petNameFocusNode,
                        controller: petNameTextEditingController),
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
                      color: AppColors.primary,
                      hintText: context.tr(AppStrings.enterPetAge),
                      textInputType: TextInputType.number,
                      focusNode: petAgeFocusNode,
                      controller: petAgeTextEditingController,
                      interactionEnabled: false,
                      isSeparatorNeeded: true,
                      maxCharacters: 2,
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
                      onChanged: petClassSelected,
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
                        setState(() {
                          if (value == context.tr(AppStrings.unknown)) {
                            isEnabled = false;
                            isHybrid = false;
                            secondSpeciesKey.currentState!.changeSelectedItem(
                                context.tr(AppStrings.unknown));
                          } else {
                            isEnabled = true;
                            secondSpeciesKey.currentState?.removeItem(value!);
                          }
                        });
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
                                    // secondSpeciesKey.currentState!
                                    //     .changeSelectedItem(
                                    //         context.tr(AppStrings.unknown));
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
                      items: (filter, infiniteScrollProps) =>
                          selectedSpeciesList
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
                              onPressed: popCurrencyPicker,
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
                            color: AppColors.primary,
                            isTextCentered: true,
                            isSeparatorNeeded: true,
                            focusNode: priceFocusNode,
                            controller: priceTextEditingController,
                            textInputType: TextInputType.number,
                            hintText: context.tr(AppStrings.enterPrice),
                            interactionEnabled: false,
                            maxCharacters: 9,
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
                      color: AppColors.primary,
                      maxLines: 5,
                      focusNode: descriptionFocusNode,
                      controller: descriptionTextEditingController,
                      textInputType: TextInputType.multiline,
                      hintText: context.tr(AppStrings.enterReason),
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

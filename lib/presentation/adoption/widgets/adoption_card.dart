import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pawsome/domain/auth/entity/user.dart';
import 'package:pawsome/domain/pet/entity/pet.dart';
import 'package:pawsome/presentation/adoption/bloc/adoption_cubit.dart';
import '../../../core/theme/app_strings.dart';
import '../../../core/utils/functions.dart';
import '../pages/pet_details.dart';
import 'like_animation.dart';

class AdoptionCard extends StatefulWidget {
  final PetEntity pet;
  final int index;
  final UserEntity user;
  const AdoptionCard(
      {super.key, required this.pet, required this.index, required this.user});

  @override
  State<AdoptionCard> createState() => _AdoptionCardState();
}

class _AdoptionCardState extends State<AdoptionCard> {
  @override
  void initState() {
    super.initState();
    // DefaultCacheManager().emptyCache();
    // imageCache.clear();
    // imageCache.clearLiveImages();
  }

  Future<String> getDistance() async {
    return await context
        .read<AdoptionCubit>()
        .getDistanceBetween(widget.pet.getGeoPoint());
  }

  static final customCacheManager = CacheManager(
    Config(
      'registeredPets',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 100,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDistance(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final distance = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        PetDetails(pet: widget.pet, index: widget.index),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10.0),
                height: 120.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'petPicture${widget.index}',
                      child: Container(
                          height: 100.0,
                          width: 100.0,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: CachedNetworkImage(
                            // key: UniqueKey(),
                            cacheManager: customCacheManager,
                            imageUrl: widget.pet.photoUrl,
                            // maxHeightDiskCache: 50,
                            // height: 100,
                            // width: 100,
                            placeholder: (context, url) => Container(
                              color: Colors.black12,
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.black12,
                              child: const Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            ),
                          )
                          // Image.network(widget.snap['photoUrl']),
                          ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Expanded(
                          //   child: Marquee(
                          //     text: widget.snap['name'],
                          //     style: const TextStyle(
                          //         fontWeight: FontWeight.bold, fontSize: 16),
                          //   ),
                          // ),
                          Text(
                            widget.pet.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            getName(context, widget.pet.petSpecies),
                            style: const TextStyle(fontSize: 12),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            (AppStrings.yearOld
                                .plural(int.parse(widget.pet.age))),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_pin,
                                size: 18,
                                color: Colors.deepOrange,
                              ),
                              Text(
                                context.tr(AppStrings.withinDistance,
                                    args: [distance]),
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        widget.pet.gender == 'male'
                            ? const Icon(
                                Icons.male_rounded,
                                color: Colors.blue,
                              )
                            : const Icon(
                                Icons.female_rounded,
                                color: Colors.pink,
                              ),
                        Expanded(
                          child: Container(),
                        ),
                        LikeAnimation(
                          isAnimating: false,
                          // widget.snap['likes'].contains(user.uid),
                          smallLike: true,
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            alignment: Alignment.centerRight,
                            icon:
                                // Icon(Icons.abc),
                                widget.pet.likes.contains(widget.user.uid)
                                    ? const Icon(
                                        Icons.favorite_outlined,
                                        color: Colors.pink,
                                        size: 28.0,
                                      )
                                    : const Icon(
                                        Icons.favorite_outline,
                                        color: Colors.pink,
                                        size: 28.0,
                                      ),
                            onPressed: () async {
                              // await FirestoreMethods.likePost(widget.snap['postId'],
                              //     user.uid, widget.snap['likes']);
                              HapticFeedback.mediumImpact();
                            },
                          ),
                        ),
                        Text(
                          k_m_b_generator(widget.pet.likes.length),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}

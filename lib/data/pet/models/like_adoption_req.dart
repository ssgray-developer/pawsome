class LikeAdoptionReq {
  final String postId;
  final String uid;
  final List likes;
  LikeAdoptionReq(
      {required this.postId, required this.uid, required this.likes});
}

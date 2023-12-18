import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie.freezed.dart';
part 'movie.g.dart';

@freezed
abstract class Movie with _$Movie {
  const factory Movie(
      {required String movieId,
      required String title,
      required int year,
      required double rating,
      @Default(
          'https://static.wikia.nocookie.net/cartoonnetworkcizgifilmleri/images/a/a8/750px-Ben_10.jpg/revision/latest?cb=20201224101912&path-prefix=tr')
      String postUrl}) = _Movie;
  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
}

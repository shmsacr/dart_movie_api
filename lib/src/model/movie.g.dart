// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MovieImpl _$$MovieImplFromJson(Map<String, dynamic> json) => _$MovieImpl(
      movieId: json['movieId'] as String,
      title: json['title'] as String,
      year: json['year'] as int,
      rating: (json['rating'] as num).toDouble(),
      postUrl: json['postUrl'] as String? ??
          'https://static.wikia.nocookie.net/cartoonnetworkcizgifilmleri/images/a/a8/750px-Ben_10.jpg/revision/latest?cb=20201224101912&path-prefix=tr',
    );

Map<String, dynamic> _$$MovieImplToJson(_$MovieImpl instance) =>
    <String, dynamic>{
      'movieId': instance.movieId,
      'title': instance.title,
      'year': instance.year,
      'rating': instance.rating,
      'postUrl': instance.postUrl,
    };

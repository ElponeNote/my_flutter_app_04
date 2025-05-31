import 'dart:io';
import 'package:flutter/widgets.dart';
import '../models/music.dart';

String _safeFilename(String s) {
  // 영문, 숫자, 한글, 언더스코어, 하이픈만 허용
  return s.replaceAll(RegExp(r'[^\w\-가-힣]'), '_');
}

String? getLocalAlbumArtAssetPath(Music music) {
  final title = _safeFilename(music.title);
  final artist = _safeFilename(music.artist);
  // 확장자 우선순위: jpg, png
  for (final ext in ['jpg', 'png', 'jpeg', 'webp']) {
    final path = 'assets/album_covers/${title}_${artist}.$ext';
    if (File(path).existsSync()) {
      return path;
    }
  }
  return null;
}

ImageProvider getMusicImageProvider(Music music) {
  final assetPath = getLocalAlbumArtAssetPath(music);
  if (assetPath != null) {
    return AssetImage(assetPath);
  } else {
    return NetworkImage(music.albumArtUrl);
  }
} 
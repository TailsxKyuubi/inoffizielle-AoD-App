import 'package:pigeon/pigeon_lib.dart';

class TextureMessage {
  int textureId;
}

class LoopingMessage {
  int textureId;
  bool isLooping;
}

class VolumeMessage {
  int textureId;
  double volume;
}

class PlaybackSpeedMessage {
  int textureId;
  double speed;
}

class PositionMessage {
  int textureId;
  int position;
}

class CreateMessage {
  String asset;
  String uri;
  String packageName;
  String formatHint;
}

class MixWithOthersMessage {
  bool mixWithOthers;
}

@HostApi(dartHostTestHandler: 'TestHostVideoPlayerApi')
abstract class VideoPlayerApi {
  void initialize();
  TextureMessage create(CreateMessage msg);
  void dispose(TextureMessage msg);
  void setLooping(LoopingMessage msg);
  void setVolume(VolumeMessage msg);
  void setPlaybackSpeed(PlaybackSpeedMessage msg);
  void play(TextureMessage msg);
  PositionMessage position(TextureMessage msg);
  void seekTo(PositionMessage msg);
  void pause(TextureMessage msg);
  void setMixWithOthers(MixWithOthersMessage msg);
}

void configurePigeon(PigeonOptions opts) {
  opts.dartOut = '../video_player_platform_interface/lib/messages.dart';
  opts.objcHeaderOut = 'ios/Classes/messages.h';
  opts.objcSourceOut = 'ios/Classes/messages.m';
  opts.objcOptions.prefix = 'FLT';
  opts.javaOut =
      'android/src/main/java/io/flutter/plugins/videoplayer/Messages.java';
  opts.javaOptions.package = 'io.flutter.plugins.videoplayer';
}

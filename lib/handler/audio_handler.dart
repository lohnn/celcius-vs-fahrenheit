import 'package:flame_audio/flame_audio.dart';

class AudioHandler {
  late List<String> _audioFiles;

  // audio
  final String backgroundMusic = 'Space.mp3';
  final String victoryMusic = 'victory.mp3';

  // Audio

  Future<void> init() async {
    _audioFiles = [
      backgroundMusic,
      victoryMusic,
    ];

    await FlameAudio.audioCache.loadAll(_audioFiles);

    // kick start background music observer
    FlameAudio.bgm.initialize();
  }

  bool isPlaying() {
    return FlameAudio.bgm.isPlaying;
  }

  void playBackgroundMusic({double? volume}) {
    _playBackground(backgroundMusic, volume: volume);
  }

  Future<void> playWinning() async {
    await _playBackground(victoryMusic);
  }

  Future<void> stopBackgroundMusic() async {
    await FlameAudio.bgm.stop();
  }

  Future<void> _playBackground(String musicFile, {double? volume}) async {
    await FlameAudio.bgm.stop();
    await FlameAudio.bgm.play(musicFile, volume: volume ?? 0.25);
  }

  void destroy() {
    FlameAudio.bgm.dispose();
    FlameAudio.audioCache.clearAll();
  }
}

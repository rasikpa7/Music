import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:newmusic/screens/settings.dart';

final assetsAudioPlayer = AssetsAudioPlayer();
void play(List<Audio> audio, int index) {
  //int index = ind == null ? 0 : ind;
  assetsAudioPlayer.open(Playlist(audios: audio, startIndex: index),
      showNotification: notification,
      notificationSettings: NotificationSettings(stopEnabled: false));
}

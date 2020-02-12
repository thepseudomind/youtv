import 'package:scoped_model/scoped_model.dart';
import '../models/channel.dart';

mixin ChannelsModel on Model{
  List<Channel> _channels = [
    Channel(name: 'Channels', logo: 'assets/channels.jpeg', link: 'https://firebasestorage.googleapis.com/v0/b/youtvapi.appspot.com/o/Concussion.mp4?alt=media&token=9c15437e-5b60-4ecb-93c0-3bdcfd1834a9'),
    Channel(name: 'WWE 2020', logo: 'assets/wwe.jpeg', link: 'https://www.filmon.com/tv/channel/export?channel_id=3602&autoPlay=1'),
  ];

  List<Channel> get channels{
    return List.from(_channels);
  }

}
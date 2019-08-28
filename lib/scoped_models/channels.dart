import 'package:scoped_model/scoped_model.dart';
import '../models/channel.dart';

mixin ChannelsModel on Model{
  List<Channel> _channels = [
    Channel(name: 'Asian Food Channel', logo: 'assets/asianfoodchannel.jpg', link: ''),
    Channel(name: 'FOX Channel', logo: 'assets/fox.jpg', link: ''),
    Channel(name: 'MTV', logo: 'assets/mtv.jpg', link: ''),
    Channel(name: 'nBC', logo: 'assets/nbc.jpg', link: ''),
    Channel(name: 'Sky TV', logo: 'assets/sky.jpg', link: ''),
    Channel(name: 'ZeeWorld', logo: 'assets/zeetv.jpg', link: '')
  ];

  List<Channel> get channels{
    return List.from(_channels);
  }

}
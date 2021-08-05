import 'package:ioesolutions/src/providers/homepage_provider.dart';

class HomepageRepository{
  HomepageProvider homepageProvider = new HomepageProvider();
  Future fetchInitialData()async
  {
      var response = await homepageProvider.fetchInitialData();
      return response;
  }

}


import 'package:ioesolutions/src/providers/homepage_provider.dart';
import 'package:ioesolutions/src/providers/notice_provider.dart';

class NoticeRepository{
  NoticeProvider noticeProvider = new NoticeProvider();
  Future fetchNotices(int start,int limit)async
  {
      var response = await noticeProvider.fetchNotices(startIndex: start,limit: limit);
      return response;
  }

}


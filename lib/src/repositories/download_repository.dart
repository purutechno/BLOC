import 'package:ioesolutions/src/blocs/download/download_event.dart';
import 'package:ioesolutions/src/providers/download_provider.dart';

class DownloadRepository{
  DownloadProvider downloadProvider = new DownloadProvider();
  Future LoadPdfOnline({fileId})async
  {
    
      var response = await downloadProvider.loadPdfOnline(file_id:fileId);
      return response;
  }
}
// Facade aman-Web untuk DownloadManager (IO di Android, no-op di Web).
export 'download_backend_stub.dart'
    if (dart.library.io) 'download_backend_io.dart';

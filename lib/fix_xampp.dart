import 'dart:io';

import 'package:mysql/copy_file.dart';
import 'package:path/path.dart';

Future<void> fixXampp(String xamppPath) async {
  await copyPath(
    join(xamppPath, 'mysql', 'data'),
    join(xamppPath, 'mysql', 'data_old'),
  );
  await copyPath(
    join(xamppPath, 'mysql', 'backup', 'mysql'),
    join(xamppPath, 'mysql', 'data', 'mysql'),
  );
  await copyPath(
    join(xamppPath, 'mysql', 'backup', 'performance_schema'),
    join(xamppPath, 'mysql', 'data', 'performance_schema'),
  );
  await copyPath(
    join(xamppPath, 'mysql', 'backup', 'phpmyadmin'),
    join(xamppPath, 'mysql', 'data', 'phpmyadmin'),
  );
  await Directory(join(xamppPath, 'mysql', 'data_old')).delete(recursive: true);
}

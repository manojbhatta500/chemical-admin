import 'package:apiadmin/apis.dart';
import 'package:dio/dio.dart';

class PostChemicalDataRepository {
  final dio = Dio();

  Future<int> postChemicalData(
      {required String filePath,
      required String fileName,
      required String cName,
      required String sName}) async {
    try {
      Response response = await dio.post(Apis.postUrlApi,
          data: FormData.fromMap({
            'file': await MultipartFile.fromFile(filePath, filename: fileName),
            'scientificName': sName,
            'commanName': cName,
          }),
          options: Options(
            headers: {
              'Content-Type': 'multipart/form-data',
            },
          ));

      print(response.statusCode.toString());
      print(response.toString());
      if (response.statusCode == 200) {
        return 1;
      } else {
        return 0;
      }
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }
}

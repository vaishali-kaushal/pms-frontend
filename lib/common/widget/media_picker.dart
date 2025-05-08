import 'dart:io';
import 'package:performance_management_system/pms.dart';

Future<String?> openImagePicker({VoidCallback? onPickerTap,bool isShowFile = false}) async {
  ImageSource? source;
  int? indexes;
  await Get.bottomSheet(
    BottomSheet(
      onClosing: () {},
      builder: (con) {
        return ImagePickerBox(
          isShowFile: isShowFile,
          onOptionTap: (value,index) {
            source = value;
            indexes = index;
            Get.back();
          },
        );
      },
    ),
  );

  try {
    if (source != null) {
      if (onPickerTap != null) {
        onPickerTap();
      }
      if((source == ImageSource.camera && indexes == 0) || (source == ImageSource.gallery && indexes == 1)){
        XFile? xFile = await ImagePicker().pickImage(source: source!);
        if(xFile != null){
          File? compFile = await compressImage(File(xFile.path));
          return compFile?.path;
        }}
      else if(source == ImageSource.gallery && indexes == 2){

        FilePickerResult? xFile = await FilePicker.platform.pickFiles(
            allowMultiple: false,
            type: FileType.custom,
            allowedExtensions: ['png', 'jpg', 'jpeg'] //, 'pdf'
        );
        if(xFile != null){
          String xyz = xFile.files.first.path!.split("/").last;
          String abc = xyz.split(".").last;
          if(abc == "pdf"){
           /* String? compPdf = await compressPdf(xFile.files.first.path.toString());
            return compPdf;*/
          }else{
            File? compFile = await compressImage(File(xFile.files.first.path.toString()));
            return compFile?.path;
          }
        }
      }
    }
  } catch (e) {
    errorToast(e.toString());
   // showErrorMsg(e.toString());
  }
  return null;
}

Future<List<String>> openMultiImagePicker({VoidCallback? onPickerTap}) async {
  ImageSource? source;
  int? indexes;
  await Get.bottomSheet(
    BottomSheet(
      onClosing: () {},
      builder: (con) {
        return ImagePickerBox(
          onOptionTap: (value,index) {
            source = value;
            indexes = index;
            Get.back();
          },
        );
      },
    ),
  );

  try {
    if (source != null) {
      if (onPickerTap != null) {
        onPickerTap();
      }
      if (source == ImageSource.camera && indexes == 0) {
        XFile? xFile = await ImagePicker().pickImage(source: source!,imageQuality: 50);
        File? comFile = await compressImage(File(xFile!.path));
        return comFile == null ? [] : [comFile.path];
      } else if(source == ImageSource.gallery && indexes == 1){
        List<XFile> list = await ImagePicker().pickMultiImage(imageQuality: 50);
        List<String> pathList = [];
        for(var xFile in list){
          File? comFile = await compressImage(File(xFile.path));
          if(comFile != null){
            pathList.add(comFile.path);
          }
        }
        return pathList;

      }
    }
  } catch (e) {
    print(e.toString());
  }
  return [];
}

class ImagePickerBox extends StatelessWidget {

  final Function(ImageSource,int index) onOptionTap;
  bool isShowFile;

  ImagePickerBox({Key? key, required this.onOptionTap,this.isShowFile = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildBox(
              AssetRes.cameraImage,
              "camera".tr,
                  () => onOptionTap(ImageSource.camera,0),
            ),
            buildBox(
              AssetRes.galleryImage,
              "gallery".tr,
                  () => onOptionTap(ImageSource.gallery,1),
            ),
            /*Visibility(
              visible: isShowFile,
              child: buildBox(
                AssetRes.fileImage,
                "file".tr,
                    () => onOptionTap(ImageSource.gallery,2),
              ),
            ),*/
          ],
        )
    );
  }

  Widget buildBox(String image, String title, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.only(
        top: Get.height / 40,
        bottom: Get.height / 60,
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(Get.width / 25),
              decoration: const BoxDecoration(
                color: ColorRes.lightGreyColor,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                image,
                height: Get.width / 12,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: styleW600S16.copyWith(color: ColorRes.black),
            ),
          ],
        ),
      ),
    );
  }
}

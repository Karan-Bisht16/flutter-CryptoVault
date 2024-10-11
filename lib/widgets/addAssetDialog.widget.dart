import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cryptovault/controllers/assets.controller.dart';
import 'package:cryptovault/services/http.service.dart';
import 'package:cryptovault/models/apiResponse.model.dart';

class AddAssetDialogController extends GetxController {
  RxBool loading = false.obs;
  RxList<String> assets = <String>[].obs;
  RxString selectedAsset = "".obs;
  RxDouble assetValue = 0.0.obs;
  // RxString error = "".obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    loading.value = true;
    HTTPService httpService = Get.find();
    var responseData = await httpService.get("currencies");
    CurrenciesListAPIResponse response =
        CurrenciesListAPIResponse.fromJson(responseData);
    response.data?.forEach((coin) {
      assets.add(coin.name!);
    });
    selectedAsset.value = assets.first;
    loading.value = false;
  }
}

class AddAssetDialog extends StatelessWidget {
  AddAssetDialog({super.key});

  final controller = Get.put(AddAssetDialogController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Center(
        child: Material(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            height: MediaQuery.sizeOf(context).height * 0.40,
            width: MediaQuery.sizeOf(context).width * 0.90,
            decoration: const BoxDecoration(
              color: Colors.black26,
            ),
            child: dialogContent(context),
          ),
        ),
      ),
    );
  }

  Widget dialogContent(BuildContext context) {
    if (controller.loading.isTrue) {
      return const Center(
        child: CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation(Color(0xFF27A2F7)),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton(
              value: controller.selectedAsset.value,
              items: controller.assets.map((coin) {
                return DropdownMenuItem(
                  value: coin,
                  child: Text(coin),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.selectedAsset.value = value;
                }
              },
            ),
            AssetAmoutTextField(controller: controller),
            // Opacity(
            //   opacity: controller.error.value != "" ? 1 : 0,
            //   child: Text(
            //     controller.error.value,
            //     style: const TextStyle(color: Colors.red),
            //   ),
            // ),
            AddAssetButton(controller: controller)
          ],
        ),
      );
    }
  }
}

class AssetAmoutTextField extends StatelessWidget {
  const AssetAmoutTextField({
    super.key,
    required this.controller,
  });

  final AddAssetDialogController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        controller.assetValue.value = double.parse(value);
      },
      cursorColor: const Color(0xFF27A2F7),
      keyboardType: const TextInputType.numberWithOptions(),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF27A2F7)),
        ),
      ),
    );
  }
}

class AddAssetButton extends StatelessWidget {
  const AddAssetButton({
    super.key,
    required this.controller,
  });

  final AddAssetDialogController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: MediaQuery.sizeOf(context).width,
      onPressed: () {
        // if (controller.assetValue.value != 0) {
        AssetsController assetsController = Get.find();
        assetsController.addAsset(
          controller.selectedAsset.value,
          controller.assetValue.value,
        );
        Get.back(closeOverlays: true);
        // controller.error.value = "";
        // } else {
        // controller.error.value = "Enter a value first.";
        // }
      },
      color: const Color(0xFF27A2F7),
      child: const Text("Add asset"),
    );
  }
}

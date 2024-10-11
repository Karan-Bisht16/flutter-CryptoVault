import 'dart:convert';
import 'package:get/get.dart';
import 'package:cryptovault/models/trackedAsset.model.dart';
import 'package:cryptovault/models/apiResponse.model.dart';
import 'package:cryptovault/models/coinData.model.dart';
import 'package:cryptovault/services/http.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssetsController extends GetxController {
  RxBool loading = false.obs;
  RxList<TrackedAsset> trackedAssets = <TrackedAsset>[].obs;
  RxList<CoinData> coinData = <CoinData>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAsset();
    loadTrackedAssetsFromStorage();
  }

  Future<void> getAsset() async {
    loading.value = true;
    HTTPService httpService = Get.find();
    var responseData = await httpService.get("currencies");
    CurrenciesListAPIResponse response =
        CurrenciesListAPIResponse.fromJson(responseData);
    coinData.value = response.data ?? [];
    loading.value = false;
  }

  void updateTrackedAssetsInStorage() async {
    List<String> trackedAssetsData =
        trackedAssets.map((asset) => jsonEncode(asset)).toList();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("trackedAssets", trackedAssetsData);
  }

  void loadTrackedAssetsFromStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? trackedAssetsData = prefs.getStringList("trackedAssets");
    if (trackedAssetsData != null) {
      trackedAssets.value = trackedAssetsData
          .map((asset) => TrackedAsset.fromJson(jsonDecode(asset)))
          .toList();
    }
  }

  void addAsset(String name, double amount) async {
    bool flag = true;
    RxList<TrackedAsset> newList = <TrackedAsset>[].obs;

    for (TrackedAsset asset in trackedAssets) {
      if (asset.name == name) {
        asset.amount = asset.amount! + amount;
        flag = false;
      }
      newList.add(asset);
    }

    if (flag) {
      trackedAssets.add(TrackedAsset(
        name: name,
        amount: amount,
      ));
    } else {
      trackedAssets.value = newList;
    }

    updateTrackedAssetsInStorage();
  }

  void removeAsset(String name) {
    RxList<TrackedAsset> newList = <TrackedAsset>[].obs;

    for (TrackedAsset asset in trackedAssets) {
      if (asset.name != name) {
        newList.add(asset);
      }
    }

    trackedAssets.value = newList;
    updateTrackedAssetsInStorage();

    Get.back();
  }

  void editAsset(String name, double amount) {}

  double getPortfolioValue() {
    if (trackedAssets.isEmpty || coinData.isEmpty) {
      return 0;
    }
    double value = 0;
    for (TrackedAsset asset in trackedAssets) {
      value += getAssetPrice(asset.name!, asset.amount!);
    }
    return value;
  }

  double getAssetPrice(String name, double amount) {
    return getAssetValue(name) * amount;
  }

  double getAssetValue(String name) {
    CoinData? data = getCoinData(name);
    return data?.values?.uSD?.price?.toDouble() ?? 0;
  }

  CoinData? getCoinData(String name) {
    return coinData.firstWhereOrNull((e) => e.name == name);
  }
}

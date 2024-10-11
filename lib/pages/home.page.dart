import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cryptovault/controllers/assets.controller.dart';
import 'package:cryptovault/models/trackedAsset.model.dart';
import 'package:cryptovault/pages/detail.page.dart';
import 'package:cryptovault/utils/utils.dart';
import 'package:cryptovault/widgets/addAssetDialog.widget.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final AssetsController assetsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 70,
        title: const AppBarContent(),
        backgroundColor: const Color(0xFF020412),
        actions: [
          IconButton(
            onPressed: () {
              Get.dialog(AddAssetDialog());
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: BodyContent(assetsController: assetsController),
      ),
      backgroundColor: const Color(0xFF020412),
    );
  }
}

class AppBarContent extends StatelessWidget {
  const AppBarContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
              "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg"),
        ),
        SizedBox(
          width: 16.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "CryptoVault",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              "A competely legit crypto app. Trust me bro!",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BodyContent extends StatelessWidget {
  const BodyContent({
    super.key,
    required this.assetsController,
  });

  final AssetsController assetsController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Container(
          color: const Color(0xFF020412),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              portfolioValue(context),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.03,
                child: const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    "My Portfolio",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              assetsList(context),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget portfolioValue(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.03,
      ),
      child: Center(
        child: Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            children: [
              const TextSpan(
                text: "\$",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text:
                    "${assetsController.getPortfolioValue().toStringAsFixed(2)}\n",
                style: const TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const TextSpan(
                text: "Portfolio value",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget assetsList(BuildContext context) {
    if (assetsController.loading.isTrue) {
      return const Center(
        child: CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation(Color(0xFF27A2F7)),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: MediaQuery.sizeOf(context).width * 0.02,
        ),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const ScrollPhysics(),
              itemCount: assetsController.trackedAssets.length,
              itemBuilder: (context, index) {
                TrackedAsset asset = assetsController.trackedAssets[index];
                return ListTile(
                  leading: Image.network(
                    getCryptoImageURL(asset.name!),
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return const SizedBox(
                        height: 56,
                        width: 56,
                        child: Center(
                            child: Text(
                          '😢',
                          style: TextStyle(fontSize: 40),
                        )),
                      );
                    },
                  ),
                  title: Text("${asset.name!} "),
                  subtitle: Text(
                      "Total Value: \$ ${assetsController.getAssetPrice(asset.name!, asset.amount!).toStringAsFixed(2)}"),
                  trailing: Text(asset.amount.toString()),
                  onTap: () {
                    Get.to(() {
                      return Detail(
                        coin: assetsController.getCoinData(asset.name!)!,
                        assetsController: assetsController,
                      );
                    });
                  },
                );
              }),
        ),
      );
    }
  }
}

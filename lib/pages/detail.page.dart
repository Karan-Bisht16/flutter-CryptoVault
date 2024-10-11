import 'package:flutter/material.dart';
import 'package:cryptovault/controllers/assets.controller.dart';
import 'package:cryptovault/models/coinData.model.dart';
import 'package:cryptovault/utils/utils.dart';

class Detail extends StatelessWidget {
  const Detail({
    super.key,
    required this.coin,
    required this.assetsController,
  });

  final CoinData coin;
  final AssetsController assetsController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(coin.name!),
        centerTitle: true,
        backgroundColor: const Color(0xFF020412),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.sizeOf(context).width * 0.02,
            right: MediaQuery.sizeOf(context).width * 0.02,
            bottom: MediaQuery.sizeOf(context).width * 0.04,
          ),
          child: Column(
            children: [
              assetPrice(context),
              assetInfo(context),
              // editAssetAmount(context),
              removeAsset(context),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFF020412),
    );
  }

  Widget assetPrice(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.10,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.network(
              getCryptoImageURL(coin.name!),
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
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      "Current Price: \$ ${coin.values?.uSD?.price?.toStringAsFixed(2)}\n",
                  style: const TextStyle(fontSize: 25),
                ),
                TextSpan(
                  text:
                      "${coin.values?.uSD?.percentChange24h?.toStringAsFixed(2)} %",
                  style: TextStyle(
                    fontSize: 15,
                    color: coin.values!.uSD!.percentChange24h! > 0
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget assetInfo(BuildContext context) {
    return Expanded(
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
        ),
        children: [
          infoCard(
            "Circulating Supply",
            coin.circulatingSupply.toString(),
          ),
          infoCard(
            "Maximum Supply",
            coin.maxSupply.toString(),
          ),
          infoCard(
            "Total Supply",
            coin.totalSupply.toString(),
          ),
        ],
      ),
    );
  }

  Widget infoCard(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF27A2F7),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget removeAsset(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        assetsController.removeAsset(coin.name!);
      },
      color: Colors.red[500],
      minWidth: MediaQuery.sizeOf(context).width,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          "Remove Asset",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}

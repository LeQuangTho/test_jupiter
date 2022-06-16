import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:solana/metaplex.dart' hide Image;
import 'package:solana/solana.dart';
import 'package:test_jupiter/colors.dart';
import 'package:test_jupiter/constants.dart';
import 'package:test_jupiter/nft.dart';
import 'package:test_jupiter/solana_extension.dart';

class CollectionNFTsView extends StatefulWidget {
  const CollectionNFTsView({Key? key}) : super(key: key);

  @override
  State<CollectionNFTsView> createState() => _CollectionNFTsViewState();
}

class _CollectionNFTsViewState extends State<CollectionNFTsView> {
  late Size size;
  Map<String, Future<OffChainMetadata>> nfts = {};

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: nfts.length,
        itemBuilder: (context, index) => FutureBuilder<OffChainMetadata>(
          future: nfts[nfts.keys.elementAt(index)],
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Container();
            } else {
              return Material(
                elevation: 8,
                color: index.isEven
                    ? const Color(0xfffd6f49)
                    : TJColors.primaryColor,
                child: Row(
                  children: [
                    Container(
                      height: size.width * 0.2,
                      width: size.width * 0.2,
                      padding: EdgeInsets.all(size.width * 0.01),
                      margin: EdgeInsets.symmetric(
                        horizontal: size.width * 0.05,
                        vertical: size.width * 0.02,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white.withOpacity(0.25),
                      ),
                      child: Image.network(
                        "${snapshot.data?.image}",
                      ),
                    ),
                    Text(
                      snapshot.data!.name,
                      style: Theme.of(context).textTheme.headline2!.copyWith(
                            fontSize: 16,
                          ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Ed25519HDKeyPair ed25519hdKeyPair =
              await Ed25519HDKeyPair.fromMnemonic(
            "tip couple glide injury stick reward inhale coach rail thank media gun",
          );

          /// Get SPL Account
          final accounts = await solanaClientDev.getSplAccounts(
            ed25519hdKeyPair.address,
          );

          /// Get List nft mint
          final nftMints =
              accounts.map((d) => d.toNftAccountDataOrNull()).whereNotNull();

          // return;

          ///Get nft collection
          List<NonFungibleToken?> nftCollection = await Future.wait(
            nftMints.map(
              (info) async {
                final metadata = await solanaClientDev.rpcClient.getMetadata(
                  mint: Ed25519HDPublicKey.fromBase58(
                    info.mint,
                  ),
                );

                return metadata == null
                    ? null
                    : NonFungibleToken(
                        address: info.mint,
                        metadata: metadata,
                      );
              },
            ),
          );

          for (var element in nftCollection) {
            if (element != null) {
              logger.e(element.metadata.uri);
              nfts.putIfAbsent(
                element.metadata.mint,
                () async {
                  return element.metadata.getExternalJson();
                },
              );
            }
          }
          setState(() {});
        },
        label: const Text(
          "Get NFTs Collection",
        ),
      ),
    );
  }
}

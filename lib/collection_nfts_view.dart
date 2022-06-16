import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:solana/metaplex.dart' hide Image;
import 'package:solana/solana.dart';
import 'package:test_jupiter/constants.dart';
import 'package:test_jupiter/nft.dart';
import 'package:test_jupiter/solana_extension.dart';

class CollectionNFTsView extends StatefulWidget {
  const CollectionNFTsView({Key? key}) : super(key: key);

  @override
  State<CollectionNFTsView> createState() => _CollectionNFTsViewState();
}

class _CollectionNFTsViewState extends State<CollectionNFTsView> {
  Map<String, Future<OffChainMetadata>> nfts = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: nfts.length,
        itemBuilder: (context, index) => FutureBuilder<OffChainMetadata>(
          future: nfts[nfts.keys.elementAt(index)],
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Container();
            } else {
              return Image.network("${snapshot.data?.image}");
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

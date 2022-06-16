import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solana/metaplex.dart' hide Image;
import 'package:test_jupiter/offchain_metadata_repository.dart';

class NftTile extends StatelessWidget {
  const NftTile({
    Key? key,
    required this.metadata,
  }) : super(key: key);

  final Metadata metadata;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () {
          // context.router.navigate(NftDetailsRoute(metadata: metadata));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: NftImage(metadata: metadata, size: 90),
              ),
              Expanded(
                child: Text(
                  metadata.name,
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      ?.copyWith(fontSize: 19),
                ),
              )
            ],
          ),
        ),
      );
}

class NftImage extends StatefulWidget {
  const NftImage({
    Key? key,
    required this.metadata,
    required this.size,
  }) : super(key: key);

  final Metadata metadata;
  final double size;

  @override
  State<NftImage> createState() => _NftImageState();
}

class _NftImageState extends State<NftImage> {
  late final Future<OffChainMetadata> _future;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _future = context
          .read<OffchainMetadataRepository>()
          .getMetadata(widget.metadata);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<OffChainMetadata>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return SizedBox(
              width: widget.size,
              height: widget.size,
            );
          }

          final data = snapshot.data;

          return data != null
              ? _ItemImage(data: data, size: widget.size)
              : SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: const Center(child: _loadingWidget),
                );
        },
      );
}

class _ItemImage extends StatelessWidget {
  const _ItemImage({
    Key? key,
    required this.data,
    required this.size,
  }) : super(key: key);

  final double size;
  final OffChainMetadata data;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: const BoxDecoration(color: Color(0x40ffffff)),
          width: size,
          height: size,
          child: data.properties.maybeMap(
            image: (_) => Image.network(
              data.image,
              loadingBuilder: _loadingBuilder,
              width: size,
            ),
            vr: (_) => Image.network(
              data.image,
              loadingBuilder: _loadingBuilder,
              width: size,
            ),
            orElse: () => const Center(
              child: Text(
                "Unsupported Nft",
              ),
            ),
          ),
        ),
      );
}

const _loadingWidget = FractionallySizedBox(
  widthFactor: 0.4,
  heightFactor: 0.4,
  child: CircularProgressIndicator(color: Color(0x80ffffff)),
);

Widget _loadingBuilder(
  BuildContext _,
  Widget child,
  ImageChunkEvent? loadingProgress,
) =>
    loadingProgress == null ? child : _loadingWidget;

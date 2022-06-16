import 'package:solana/metaplex.dart';

abstract class OffchainMetadataRepository {
  Future<OffChainMetadata> getMetadata(Metadata metadata);
}

class OffchainMetadataRepositoryImpl implements OffchainMetadataRepository {
  final Map<String, Future<OffChainMetadata>> _requests = {};

  @override
  Future<OffChainMetadata> getMetadata(Metadata metadata) async =>
      _requests.putIfAbsent(
        metadata.mint,
            () => metadata.getExternalJson(),
      );
}
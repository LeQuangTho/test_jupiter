import 'package:solana/metaplex.dart';
import 'package:solana/solana.dart';

const isProd = bool.fromEnvironment('PROD');

const currentChainId = isProd ? _mainNetChainId : _devNetChainId;

const _mainNetChainId = 101;
const _devNetChainId = 103;

class Token {
  const Token({
    required this.chainId,
    required this.address,
    required this.symbol,
    required this.name,
    required this.decimals,
    required this.logoURI,
    required this.tags,
    required this.extensions,
  });

  const factory Token.solana() = _SolanaToken;

  const factory Token.wrappedSolana() = _WrappedSolanaToken;

  const factory Token.splToken({
    required int chainId,
    required String address,
    required String symbol,
    required String name,
    required int decimals,
    required String logoURI,
    required List<String> tags,
    required Extensions? extensions,
  }) = SplToken;

  const factory Token.nft({
    required String address,
    required Metadata metadata,
  }) = NonFungibleToken;

  factory Token.fromJson(Map<String, dynamic> data) => _$TokenFromJson(data);

  static const sol = Token.solana();

  static const wrappedSol = Token.wrappedSolana();

  bool get isSolana => this is _SolanaToken;

  String? get coingeckoId => extensions?.coingeckoId;

  bool get isStablecoin => tags?.contains('stablecoin') == true;

  Ed25519HDPublicKey get publicKey => Ed25519HDPublicKey.fromBase58(address);

  @override
  String toString() => '$address: $chainId/$symbol/$name';

  final int chainId;
  final String address;
  final String symbol;
  final String name;
  final int decimals;
  final String? logoURI;
  final List<String>? tags;
  final Extensions? extensions;
}

Token _$TokenFromJson(Map<String, dynamic> json) => Token(
      chainId: json['chainId'] as int,
      address: json['address'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      decimals: json['decimals'] as int,
      logoURI: json['logoURI'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      extensions: json['extensions'] == null
          ? null
          : Extensions.fromJson(json['extensions'] as Map<String, dynamic>),
    );

class _SolanaToken extends Token {
  const _SolanaToken()
      : super(
          address: 'So11111111111111111111111111111111111111111',
          extensions: const Extensions(
            coingeckoId: 'solana',
          ),
          logoURI:
              'https://raw.githubusercontent.com/solana-labs/token-list/main/assets/mainnet/So11111111111111111111111111111111111111112/logo.png',
          chainId: currentChainId,
          tags: const [],
          decimals: 9,
          name: 'SOL',
          symbol: 'SOL',
        );
}

class SplToken extends Token {
  const SplToken({
    required int chainId,
    required String address,
    required String symbol,
    required String name,
    required int decimals,
    String? logoURI,
    required List<String> tags,
    Extensions? extensions,
  }) : super(
          chainId: chainId,
          address: address,
          symbol: symbol,
          name: name,
          decimals: decimals,
          logoURI: logoURI,
          tags: tags,
          extensions: extensions,
        );
}

class _WrappedSolanaToken extends SplToken {
  const _WrappedSolanaToken()
      : super(
          address: 'So11111111111111111111111111111111111111112',
          extensions: const Extensions(
            coingeckoId: 'wrapped-solana',
          ),
          logoURI:
              'https://raw.githubusercontent.com/solana-labs/token-list/main/assets/mainnet/So11111111111111111111111111111111111111112/logo.png',
          chainId: currentChainId,
          tags: const [],
          decimals: 9,
          name: 'Wrapped SOL',
          symbol: 'SOL',
        );
}

class NonFungibleToken extends SplToken {
  const NonFungibleToken({
    required String address,
    required this.metadata,
  }) : super(
          chainId: currentChainId,
          address: address,
          symbol: '',
          name: '',
          decimals: 0,
          tags: const <String>[],
        );

  final Metadata metadata;
}

class Extensions {
  const Extensions({
    this.coingeckoId,
  });

  factory Extensions.fromJson(Map<String, dynamic> data) =>
      _$ExtensionsFromJson(data);

  Map<String, dynamic> toJson() {
    throw const FormatException('cannot convert token to json');
  }

  final String? coingeckoId;
}

Extensions _$ExtensionsFromJson(Map<String, dynamic> json) => Extensions(
      coingeckoId: json['coingeckoId'] as String?,
    );

Map<String, dynamic> _$ExtensionsToJson(Extensions instance) =>
    <String, dynamic>{
      'coingeckoId': instance.coingeckoId,
    };

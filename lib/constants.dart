// ignore_for_file: constant_identifier_names

import 'package:logger/logger.dart';
import 'package:solana/solana.dart';

Logger logger = Logger();

const String solana_list_token_host =
    "https://raw.githubusercontent.com/solana-labs/token-list/main/assets/mainnet/";

final solanaClientMain = SolanaClient(
  rpcUrl: Uri.parse("https://api.mainnet-beta.solana.com"),
  websocketUrl: Uri.parse("ws://api.mainnet-beta.solana.com"),
);

final solanaClientDev = SolanaClient(
  rpcUrl: Uri.parse("https://api.devnet.solana.com/"),
  websocketUrl: Uri.parse("ws://api.devnet.solana.com/"),
);

const address = "99RmPLAvr6haS3cdg78T3WrExBhZ4oPVM52nUMhk5ZhC";
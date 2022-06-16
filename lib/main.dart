import 'package:flutter/material.dart';
import 'package:jupiter_aggregator/jupiter_aggregator.dart';
import 'package:test_jupiter/constants.dart';
import 'package:test_jupiter/swap_token_view.dart';
import 'package:test_jupiter/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: toMaterialTheme(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                var indexedRoute =
                    await JupiterAggregatorClient().getIndexedRouteMap();

                debugPrint(indexedRoute.mintKeys.toString());
              },
              child: const Text(
                "Get Indexed Route Map",
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // var routes = await JupiterAggregatorClient().getQuote(
                //   inputMint: "So11111111111111111111111111111111111111112",
                //   outputMint: "NaFJTgvemQFfTTGAq2PR1uBny3NENWMur5k6eBsG5ii",
                //   amount: 1 * math.pow(10, 9).toInt(),
                //   slippage: 0.5,
                // );

                final res = await solanaClientMain.rpcClient.getTokenSupply(
                  "SRMuApVNdxXokk5GT7XD5cUUgXMBCoAz2LHeuAoKWRt",
                );

                logger.v(res.decimals);

                // logger.i(routes[0].outAmount / math.pow(10, 9).toInt());
              },
              child: const Text(
                "Get route",
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                var route = await JupiterAggregatorClient().getQuote(
                  inputMint: "EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v",
                  outputMint: "NaFJTgvemQFfTTGAq2PR1uBny3NENWMur5k6eBsG5ii",
                  amount: 1,
                );
                var swapTransactions =
                    await JupiterAggregatorClient().getSwapTransactions(
                  userPublicKey: address,
                  route: route.first,
                );

                print(swapTransactions.swapTransaction);
              },
              child: const Text(
                "Get Swap Transactions",
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "fb-swap",
        child: const Icon(Icons.navigate_next),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SwapTokenView(),
            ),
          );
        },
      ),
    );
  }
}

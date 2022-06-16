import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:jupiter_aggregator/jupiter_aggregator.dart';
import 'package:test_jupiter/collection_nfts_view.dart';
import 'package:test_jupiter/constants.dart';
import 'package:test_jupiter/enter_amount_keypad.dart';

class SwapTokenView extends StatefulWidget {
  const SwapTokenView({Key? key}) : super(key: key);

  @override
  State<SwapTokenView> createState() => _SwapTokenViewState();
}

class _SwapTokenViewState extends State<SwapTokenView> {
  final _inputSwapController = TextEditingController();
  final _outSwapController = TextEditingController();

  List<JupiterRoute> routes = [];

  @override
  void initState() {
    _inputSwapController.addListener(() async {
      routes = await JupiterAggregatorClient().getQuote(
        inputMint: "So11111111111111111111111111111111111111112",
        outputMint: "NaFJTgvemQFfTTGAq2PR1uBny3NENWMur5k6eBsG5ii",
        amount: ((double.tryParse(_inputSwapController.text) ?? 0) *
                math.pow(10, 9).toInt())
            .toInt(),
      );

      if (routes.isNotEmpty) {
        _outSwapController.text =
            "~${routes[0].outAmount / math.pow(10, 9).toInt()}";
      } else {
        _outSwapController.text = "~0.00";
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.shade400,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextField(
                        controller: _inputSwapController,
                        readOnly: true,
                        textAlign: TextAlign.right,
                        style: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(fontSize: 20),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                          ),
                          hintText: "~0.00",
                          hintStyle:
                              Theme.of(context).textTheme.headline1!.copyWith(
                                    color: Colors.white.withOpacity(0.4),
                                    fontSize: 20,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    // fit: FlexFit.tight,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Image.network(
                        "$solana_list_token_host/So11111111111111111111111111111111111111112/logo.png",
                        errorBuilder: (context, error, stackTrace) =>
                            Container(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.shade400,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextField(
                        controller: _outSwapController,
                        readOnly: true,
                        textAlign: TextAlign.right,
                        style: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(fontSize: 20),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                          ),
                          hintText: "~0.00",
                          hintStyle:
                              Theme.of(context).textTheme.headline1!.copyWith(
                                    color: Colors.white.withOpacity(0.4),
                                    fontSize: 20,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child:
                          Image.asset("assets/icons/nagakingdom-naga-logo.png"),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: EnterAmountKeypad(
                  maxDecimals: 3,
                  controller: _inputSwapController,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            heroTag: "fb-swap",
            onPressed: () {
              if (routes.isNotEmpty) {
                final transaction =
                    JupiterAggregatorClient().getSwapTransactions(
                  userPublicKey: "Amz5fuuKUX1jUYL11FsjsdgHLN425PU3upmvxk5j3Srp",
                  route: routes.first,
                );
              }
            },
            backgroundColor: Colors.yellow,
            child: const Text(
              "Swap",
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
          FloatingActionButton(
            heroTag: "fb-swap-1",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CollectionNFTsView(),
                ),
              );
            },
            backgroundColor: Colors.yellow,
            child: const Icon(
              Icons.navigate_next,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

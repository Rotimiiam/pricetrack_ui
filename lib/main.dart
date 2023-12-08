import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/html.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cryptocurrency Prices',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final channel = HtmlWebSocketChannel.connect(
      'wss://stream.binance.com:9443/ws/btcusdt@ticker/bnbusdt@ticker/ethusdt@ticker/solusdt@ticker');

  Map<String, String> _prices = {};

  @override
  void initState() {
    super.initState();

    channel.stream.listen((message) {
      final json = jsonDecode(message);
      final symbol = json['s'];
      final price = json['c'];
      setState(() {
        _prices[symbol] = price;
      });
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cryptocurrency Prices'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        'https://i.imgur.com/BoN9kdC.png'),
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Hello, Oluwatobiloba',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top Performing Coins',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View all',
                  style: TextStyle(
                    color: Color.fromARGB(255, 33, 243, 100),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildCoinCard(
                'Bitcoin',
                '+2.56%',
                'https://www.shutterstock.com/image-vector/bitcoin-icon-sign-payment-symbol-600nw-1938997753.jpg',
                _prices['BTCUSDT'] ?? '',
              ),
              _buildCoinCard(
                'Ethereum',
                '+3.12%',
                'https://cdn.pixabay.com/photo/2021/05/24/09/15/ethereum-logo-6278329_1280.png',
                _prices['ETHUSDT'] ?? '',
              ),
              _buildCoinCard(
                'BNB',
                '+2.73%',
                'https://cryptologos.cc/logos/bnb-bnb-logo.png',
                _prices['BNBUSDT'] ?? '',
              ),
              _buildCoinCard(
                'SOL',
                '+4.61%',
                'https://c8.alamy.com/zooms/9/e1ef30212e2b42cdbeaf6e8d1fc3352f/2gy0ed8.jpg',
                _prices['SOLUSDT'] ?? '',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoinCard(String name, String percentage, String imageUrl, String price) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35.0),
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                imageUrl,
                width: 50,
                height: 50,
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                percentage,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

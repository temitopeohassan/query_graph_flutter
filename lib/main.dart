















import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
      'https://api.studio.thegraph.com/query/66484/graph-africa-demo/version/latest',
    );

    final ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(),
      ),
    );

    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'Flutter GraphQL Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfers Information'),
      ),
      body: Center(
        child: Query(
          options: QueryOptions(
  document: gql('''
    query {
      transfers(first: 5) {
        id
        sender
        receiver
        amount
      }
    }
  '''),
),

          builder: (QueryResult result, {refetch, fetchMore}) {
            if (result.hasException) {
              return Text('Error fetching transfers: ${result.exception.toString()}');
            }

            if (result.isLoading) {
              return const CircularProgressIndicator();
            }

            final List transfers = result.data?['transfers'] ?? [];
            return ListView.builder(
              itemCount: transfers.length,
              itemBuilder: (context, index) {
                final transfer = transfers[index];
                return ListTile(
                  title: Text('Sender: ${transfer['sender']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Receiver: ${transfer['receiver']}'),
                      Text('Amount: ${transfer['amount']}'),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

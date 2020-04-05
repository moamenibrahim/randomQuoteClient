import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';

import 'package:random_quote/models/models.dart';
import 'package:random_quote/repositories/repositories.dart';
import 'package:random_quote/repositories/quote_api_client.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockQuoteApiClient extends Mock implements QuoteApiClient {
  QuoteApiClient _real;

  MockQuoteApiClient(http.Client httpClient) {
    _real = QuoteApiClient(httpClient: httpClient);
    when(fetchQuote()).thenAnswer((_) => _real.fetchQuote());
  }
}

void main() {
  group('assertion', () {
    test('should assert if null', () {
      expect(
        () => QuoteApiClient(httpClient: null),
        throwsA(isAssertionError),
      );
    });
  });

  group('fetchQuote', () {
    final mockHttpClient = MockHttpClient();
    final mockQuoteApiClient = MockQuoteApiClient(mockHttpClient);
    final mockQuoteRepository =
        QuoteRepository(quoteApiClient: MockQuoteApiClient(mockHttpClient));

    test('return Quote if http call successfully', () async {
      // given
      final mockQuoteString =
          '''{"_id": "123", "quoteText": "abc", "quoteAuthor": "-"}''';
      final mockQuote = Quote.fromJson(jsonDecode(mockQuoteString));

      when(mockHttpClient
              .get('https://quote-garden.herokuapp.com/quotes/random'))
          .thenAnswer(
              (_) async => Future.value(http.Response(mockQuoteString, 200)));

      final fetchedQuote = await mockQuoteApiClient.fetchQuote();
      expect(fetchedQuote.id, mockQuote.id);
      expect(fetchedQuote.props, mockQuote.props);
      expect(fetchedQuote.quoteText, mockQuote.quoteText);
      expect(fetchedQuote.runtimeType, mockQuote.runtimeType);
      expect(fetchedQuote.quoteAuthor, mockQuote.quoteAuthor);
      expect(mockQuote.toString(), "Quote { id: 123 }");
    });

    test('return Exception if http call error', () async {
      when(mockHttpClient
              .get('https://quote-garden.herokuapp.com/quotes/random'))
          .thenAnswer((_) async =>
              Future.value(http.Response('error getting quotes', 202)));

      expect(() async => await mockQuoteApiClient.fetchQuote(),
          throwsA(isException));
    });

    test('should called fetchQuote from QuoteApiClient', () async {
      when(mockQuoteRepository.fetchQuote()).thenAnswer((_) async {
        return Future.value();
      });

      mockQuoteRepository.fetchQuote();

      verify(mockQuoteRepository.fetchQuote()).called(1);
    });
  });
}

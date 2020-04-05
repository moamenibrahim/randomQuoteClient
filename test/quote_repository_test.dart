
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:random_quote/repositories/quote_api_client.dart';
import 'package:random_quote/repositories/quote_repository.dart';

class MockQuoteApiClient extends Mock implements QuoteApiClient {}

void main() {
  group('assertion', () {
    test('should assert if null', () {
      expect(
        () => QuoteRepository(quoteApiClient: null),
        throwsA(isAssertionError),
      );
    });
  });

  group('fetchQuote', () {
    final mockQuoteRepository =
        QuoteRepository(quoteApiClient: MockQuoteApiClient());
    test('should called fetchQuote from QuoteApiClient', () async {
      when(mockQuoteRepository.fetchQuote()).thenAnswer((_) async {
        return Future.value();
      });

      mockQuoteRepository.fetchQuote();

      verify(mockQuoteRepository.fetchQuote()).called(1);
    });
  });
}

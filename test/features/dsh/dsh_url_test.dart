import 'package:agent_port/features/dsh/dsh_url_dialog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isValidDshUrl', () {
    test('accepts absolute http/https addresses', () {
      expect(isValidDshUrl('https://notmac-mini.tail73e096.ts.net:8788'), isTrue);
      expect(isValidDshUrl('http://192.168.1.10:8788'), isTrue);
      expect(isValidDshUrl('https://abc.trycloudflare.com'), isTrue);
      expect(isValidDshUrl('  https://host:8788  '), isTrue);
    });

    test('rejects what a WebView cannot load', () {
      // A schemeless host is the likely typo, and the WebView's error for it
      // says nothing useful — so it has to be caught before we store it.
      expect(isValidDshUrl('notmac-mini.tail73e096.ts.net:8788'), isFalse);
      expect(isValidDshUrl('192.168.1.10:8788'), isFalse);
      expect(isValidDshUrl(''), isFalse);
      expect(isValidDshUrl('   '), isFalse);
      expect(isValidDshUrl('https://'), isFalse); // scheme but no host
    });

    test('rejects schemes a WebView will not fetch over', () {
      expect(isValidDshUrl('ws://host:8788'), isFalse);
      expect(isValidDshUrl('file:///etc/passwd'), isFalse);
      expect(isValidDshUrl('javascript:alert(1)'), isFalse);
    });
  });
}

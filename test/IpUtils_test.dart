import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:snifferapp/services/IpUtils.dart';

void main() {
  group('White box testing of cidrToMask', () {
    test('Test 255 block generation', () {
      expect(cidrToMask(32).address, '255.255.255.255');
      expect(cidrToMask(24).address, '255.255.255.0');
      expect(cidrToMask(16).address, '255.255.0.0');
      expect(cidrToMask(8).address, '255.0.0.0');
      expect(cidrToMask(0).address, '0.0.0.0');
    });

    test('Test remaining bits addition', () {
      expect(cidrToMask(25).address, '255.255.255.128');
      expect(cidrToMask(26).address, '255.255.255.192');
      expect(cidrToMask(27).address, '255.255.255.224');

      expect(cidrToMask(23).address, '255.255.254.0');
      expect(cidrToMask(22).address, '255.255.252.0');

      expect(cidrToMask(1).address, '128.0.0.0');
      expect(cidrToMask(2).address, '192.0.0.0');
    });
  });

  group('Black box test calculateSubnetIpRange', () {
    test('Smoke test', () {
      final testAddresses = [
        '192.168.0.0',
        '192.168.0.1',
        '192.168.0.254',
        '192.168.0.255'
      ];
      for (String addr in testAddresses) {
        var results = calculateSubnetIpRange(new InternetAddress(addr), 24);
        expect(results[0].address, '192.168.0.0');
        expect(results[1].address, '192.168.0.255');
      }
    });

    test('Test two blocks', () {
      final firstBlock = [
        '192.168.0.0',
        '192.168.0.1',
        '192.168.0.126',
        '192.168.0.127'
      ];
      for (String addr in firstBlock) {
        var results = calculateSubnetIpRange(new InternetAddress(addr), 25);
        expect(results[0].address, '192.168.0.0');
        expect(results[1].address, '192.168.0.127');
      }

      final secondBlock = [
        '192.168.0.128',
        '192.168.0.129',
        '192.168.0.254',
        '192.168.0.255'
      ];
      for (String addr in secondBlock) {
        var results = calculateSubnetIpRange(new InternetAddress(addr), 25);
        expect(results[0].address, '192.168.0.128');
        expect(results[1].address, '192.168.0.255');
      }
    });
  });

  group('Edge case tests for nextIpAddress', () {
    test('Basic test', () {
      expect(nextIpAddress(new InternetAddress('192.168.0.0')).address, '192.168.0.1');
    });

    test('Test boundaries', () {
      expect(nextIpAddress(new InternetAddress('192.168.0.255')).address, '192.168.1.0');
      expect(nextIpAddress(new InternetAddress('192.168.255.255')).address, '192.169.0.0');
      expect(nextIpAddress(new InternetAddress('192.255.255.255')).address, '193.0.0.0');    });
  });

  group('Smoke test generateIpAddresses', () {
    test('Basic test', () {
      final results = generateIpAddresses(
          new InternetAddress('192.168.0.0'),
          new InternetAddress('192.168.0.3')
      );

      expect(results.length, 2);
      expect(results[0].address, '192.168.0.1');
      expect(results[1].address, '192.168.0.2');
    });

    test('Test boundary', () {
      final results = generateIpAddresses(
          new InternetAddress('192.168.0.253'),
          new InternetAddress('192.168.1.2')
      );
      expect(results.length, 4);
      expect(results[0].address, '192.168.0.254');
      expect(results[1].address, '192.168.0.255');
      expect(results[2].address, '192.168.1.0');
      expect(results[3].address, '192.168.1.1');
    });
  });
}
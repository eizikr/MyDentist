import 'package:flutter_test/flutter_test.dart';

import 'package:my_dentist/our_widgets/our_widgets.dart';
import 'package:my_dentist/our_widgets/settings.dart'; // Replace with the actual path to your file

void main() {
  test('test capitalizeFirstCharacter function', () {
    expect(capitalizeFirstCharacter('hello'), 'Hello');

    expect(capitalizeFirstCharacter(''), '');

    expect(capitalizeFirstCharacter('a'), 'A');
  });

  test('test hasCharacter function', () {
    expect(hasCharacter('abc123'), true);

    expect(hasCharacter('123!@#'), false);

    expect(hasCharacter(''), false);

    expect(hasCharacter('    '), false);
  });

  test('test hasLowerAndUpperCase function', () {
    expect(hasLowerAndUpperCase('Abc'), true);

    expect(hasLowerAndUpperCase('abc'), false);

    expect(hasLowerAndUpperCase('ABC'), false);

    expect(hasLowerAndUpperCase('Abc@'), true);

    expect(hasLowerAndUpperCase('!@#\$', hasSpacial: false), true);

    expect(hasLowerAndUpperCase(''), false);
  });

  test('test isPasswordValid function', () {
    // Test low strength
    expect(isPasswordValid('12345', strengh: PasswordStrengh.low),
        'Minimum 6 characters long');
    expect(isPasswordValid('123456', strengh: PasswordStrengh.low), 'valid');

    // Test fair strength
    expect(isPasswordValid('12345', strengh: PasswordStrengh.fair),
        'Minimum 8 characters long and 1 letter');
    expect(isPasswordValid('abcdefg', strengh: PasswordStrengh.fair),
        'Minimum 8 characters long and 1 letter');
    expect(isPasswordValid('12345678', strengh: PasswordStrengh.fair),
        'Minimum 8 characters long and 1 letter');

    // Test good strength
    expect(isPasswordValid('password', strengh: PasswordStrengh.good),
        'Minimum 8 characters long ,1 lowercase, 1 uppercase');
    expect(isPasswordValid('PASSWORD', strengh: PasswordStrengh.good),
        'Minimum 8 characters long ,1 lowercase, 1 uppercase');
    expect(
        isPasswordValid('Password1', strengh: PasswordStrengh.good), 'valid');

    // Test excellent strength
    expect(isPasswordValid('password', strengh: PasswordStrengh.excellent),
        'Minimum 8 characters long ,1 lowercase, 1 upercase, 1 spacial');
    expect(isPasswordValid('PASSWORD', strengh: PasswordStrengh.excellent),
        'Minimum 8 characters long ,1 lowercase, 1 upercase, 1 spacial');
    expect(isPasswordValid('Password1!', strengh: PasswordStrengh.excellent),
        'valid');
  });
}

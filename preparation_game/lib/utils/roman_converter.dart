class RomanConverter {
  // Static methods can be called directly without instantiating the class
  static String toRoman(int number) {
    final Map<int, String> romanMap = {
      1: 'I', 2: 'II', 3: 'III', 4: 'IV', 5: 'V',
      6: 'VI', 7: 'VII', 8: 'VIII', 9: 'IX', 10: 'X'
    };
    return romanMap[number] ?? number.toString();
  }
}
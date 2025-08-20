enum Tax {
  none(0, "0%"),
  percent10(10, "10%");

  final int value;
  final String label;

  const Tax(this.value, this.label);
}

enum Discount {
  none(0, "0%"),
  percent10(10, "10%"),
  percent20(20, "20%"),
  percent30(30, "30%");

  final int value;
  final String label;

  const Discount(this.value, this.label);
}

class step {
  int x = 0;
  int y = 0;

  step(this.x, this.y);

  @override
  String toString() {
    return '\"x\":$x, \"y\":$y';
  }

  Map toJson() => {'x': x, 'y': y};
}

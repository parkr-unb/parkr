class AnalyzerResult
{
  bool hasPass;
  bool invalidLot;
  bool blocking;
  bool multiple;
  bool alt;

  AnalyzerResult(this.hasPass, this.invalidLot, this.blocking, this.multiple,
                 this.alt);
}
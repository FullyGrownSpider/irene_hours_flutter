class Company implements Comparable<Company>{
  final String companyName;
  int pricePerHour;

  Company(this.companyName,
      [this.pricePerHour = 0]);

  @override
  int compareTo(Company other) => other.companyName.compareTo(companyName);

  @override
  String toString() {
    return companyName;
  }
}
class PackingItem {
  final String type;
  final double? quantityPerDay;
  final int? quantityPerTrip;
  final bool? required;
  final List<String>? items;
  final String? category;  // Add category field

  PackingItem({
    required this.type,
    this.quantityPerDay,
    this.quantityPerTrip,
    this.required,
    this.items,
    this.category,  // Include category in constructor
  });

  factory PackingItem.fromJson(Map<String, dynamic> json) {
    return PackingItem(
      type: json['type'],
      quantityPerDay: json['quantity_per_day']?.toDouble(),
      quantityPerTrip: json['quantity_per_trip'] is int ? json['quantity_per_trip'] : null,
      required: json['required'],
      items: (json['items'] as List?)?.map((item) => item.toString()).toList(),
      category: json['category'],  // Add category field
    );
  }
}

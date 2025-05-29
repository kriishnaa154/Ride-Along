import 'dart:convert';
import 'package:flutter/services.dart';
import 'packing_item.dart';

class PackingListProvider {
  Map<String, dynamic>? packingData;

  Future<void> loadPackingList() async {
    final String response = await rootBundle.loadString('assets/packing_list.json');
    packingData = json.decode(response);
  }

  List<PackingItem> getPackingList(String category, List<String> conditions, int days) {
    List<PackingItem> items = [];
    if (packingData == null) return items;

    // Loop through each condition (e.g. sunny, cold, rainy, etc.)
    for (var condition in conditions) {
      if (packingData!['packing_list'][category]?.containsKey(condition) ?? false) {
        for (var item in packingData!['packing_list'][category][condition]) {
          PackingItem packingItem = PackingItem.fromJson(item);
          // Calculate total quantity
          int totalQuantity = (packingItem.quantityPerDay != null)
              ? (packingItem.quantityPerDay! * days).ceil()
              : packingItem.quantityPerTrip ?? 1;
          // Set category as we don't have it in PackingItem yet
          packingItem = PackingItem(
            type: packingItem.type,
            quantityPerTrip: totalQuantity,
            category: category,  // Add category here
          );
          items.add(packingItem);
        }
      }
    }

    // Add general items for each category
    if (packingData!['packing_list'][category]?.containsKey('general') ?? false) {
      for (var item in packingData!['packing_list'][category]['general']) {
        PackingItem packingItem = PackingItem.fromJson(item);
        int totalQuantity = (packingItem.quantityPerDay != null)
            ? (packingItem.quantityPerDay! * days).ceil()
            : packingItem.quantityPerTrip ?? 1;
        // Set category as we don't have it in PackingItem yet
        packingItem = PackingItem(
          type: packingItem.type,
          quantityPerTrip: totalQuantity,
          category: category,  // Add category here
        );
        items.add(packingItem);
      }
    }

    return items;
  }

  List<PackingItem> consolidatePackingList(List<Map<String, dynamic>> tripPlans) {
    List<PackingItem> allItems = [];

    for (var trip in tripPlans) {
      // ignore: unused_local_variable
      String place = trip['placeController'].text;
      int days = int.tryParse(trip['daysController'].text) ?? 1;
      String weatherCondition = trip['weather'] ?? '';
      List<String> conditions = [weatherCondition, ...trip['activities']];

      for (String category in [
        'clothing', 'accessories', 'personal_care', 'gadgets', 
        'documents', 'emergency_items', 'food_snacks', 'miscellaneous'
      ]) {
        allItems.addAll(getPackingList(category, conditions, days));
      }
    }

    // Remove duplicate items based on 'type' and 'category'
    Set<String> uniqueItems = {};
    List<PackingItem> finalList = [];

    for (var item in allItems) {
      String uniqueKey = "${item.type}-${item.category}";  // Ensure uniqueness across types and categories
      if (!uniqueItems.contains(uniqueKey)) {
        uniqueItems.add(uniqueKey);
        finalList.add(item);
      }
    }

    return finalList;
  }
}

class FoodCategory {
  int? categoryId;
  String? categoryName;
  int? caloriesPer100g;
  int? caloriesPerCup;
  String? servingDescription;

  FoodCategory({
    this.categoryId,
    this.categoryName,
    this.caloriesPer100g,
    this.caloriesPerCup,
    this.servingDescription,
  });

  Map<String, dynamic> toMap() {
    return {
      'category_id': categoryId,
      'category_name': categoryName,
      'calories_per_100g': caloriesPer100g,
      'calories_per_cup': caloriesPerCup,
      'serving_description': servingDescription,
    };
  }

  static FoodCategory fromMap(Map<String, dynamic> map) {
    return FoodCategory(
      categoryId: map['category_id'],
      categoryName: map['category_name'],
      caloriesPer100g: map['calories_per_100g'],
      caloriesPerCup: map['calories_per_cup'],
      servingDescription: map['serving_description'],
    );
  }
}
  
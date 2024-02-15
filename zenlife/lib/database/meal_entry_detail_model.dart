class MealEntryDetail {
  int? detailId;
  int? entryId;
  int? categoryId;
  int? quantity;
  int? caloriesCalculated;

  MealEntryDetail({
    this.detailId,
    this.entryId,
    this.categoryId,
    this.quantity,
    this.caloriesCalculated,
  });

  Map<String, dynamic> toMap() {
    return {
      'detail_id': detailId,
      'entry_id': entryId,
      'category_id': categoryId,
      'quantity': quantity,
      'calories_calculated': caloriesCalculated,
    };
  }

  static MealEntryDetail fromMap(Map<String, dynamic> map) {
    return MealEntryDetail(
      detailId: map['detail_id'],
      entryId: map['entry_id'],
      categoryId: map['category_id'],
      quantity: map['quantity'],
      caloriesCalculated: map['calories_calculated'],
    );
  }
}

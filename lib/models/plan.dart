class Plan {
  Plan({
    required this.planId,
    required this.name,
    required this.price,
    required this.interval,
    required this.description,
    required this.paystackPlanCode,
  });

  String planId;
  String name;
  String price;
  String interval;
  String description;
  String paystackPlanCode;

  static List<Plan> listFromMap(List<dynamic> json) {
    return List<Plan>.from(
      json.map(
        (x) => Plan.fromMap(x),
      ),
    );
  }

  factory Plan.fromMap(Map<String, dynamic> json) => Plan(
        planId: json["plan_id"],
        name: json["name"],
        price: json["price"],
        interval: json["interval"],
        description: json["description"],
        paystackPlanCode: json["paystack_plan_code"] == null ? 'null' : json["paystack_plan_code"],
      );

  Map<String, dynamic> toMap() => {
        "plan_id": planId,
        "name": name,
        "price": price,
        "interval": interval,
        "description": description,
        "paystack_plan_code": paystackPlanCode == null ? null : paystackPlanCode,
      };
}

enum PlanType { Free, Basic, Premium, FamilyPlan }

class Permissions {
  String currentPlan;
  late PlanType planType;
  Permissions({
    required this.currentPlan,
  }) {
    if (currentPlan == 'Free') {
      planType = PlanType.Free;
    } else if (currentPlan == 'Basic') {
      planType = PlanType.Basic;
    } else if (currentPlan == 'Premium') {
      planType = PlanType.Premium;
    } else if (currentPlan == 'Family plan') {
      planType = PlanType.FamilyPlan;
    }
  }
}

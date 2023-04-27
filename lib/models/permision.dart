enum PlanType { Free, Basic, Premium, PremiumElite, Diaspora, Business }

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
    } else if (currentPlan == 'Diaspora Plan') {
      planType = PlanType.Diaspora;
    } else if (currentPlan == 'Business Plan') {
      planType = PlanType.Business;
    }
  }
}

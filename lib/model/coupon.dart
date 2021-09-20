class CouponUse
{
  final int id;
  final bool isUsed;
  final String usedTime;
  final Coupon coupon;

  CouponUse(this.id, this.isUsed, this.usedTime, this.coupon);
}

class Coupon
{
  final int id;
  final String title;
  final String description;
  final int point;
  final String imageUrl;

  Coupon(this.id, this.title, this.description, this.point, this.imageUrl);
}
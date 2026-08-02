@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'consumption view / projection of booksuppl_m'
@Metadata.ignorePropagatedAnnotations: true
define view entity zpbu_c_booksuppl_m
  as projection on zpbu_i_booksuppl_m
{
  key TravelId,
  key BookingId,
  key BookingSupplementId,
      SupplementId,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Price,
      CurrencyCode,
      LastChangedAt,
      /* Associations */
      _booking : redirected to parent zpbu_c_booking_m,
      _travel  : redirected to zpbu_c_travel_m,
      _suppl,
      _supplText
}

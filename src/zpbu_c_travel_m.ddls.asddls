@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root consumption view / Projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity zpbu_c_travel_m
  provider contract transactional_query
  as projection on ZPBU_i_TRAVEL_M
{
  key TravelId,
      AgencyId,
      _agency.Name,
      CustomerId,
      _customer.FirstName,
      BeginDate,
      EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,
      CurrencyCode,
      Description,
      OverallStatus,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      /* Associations */
      _agency,
      _booking : redirected to composition child zpbu_c_booking_m,
      _customer,
      _overallStatus
}

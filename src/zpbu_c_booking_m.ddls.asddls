@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'consumption view / projection of BOOKING_M'
@Metadata.ignorePropagatedAnnotations: true
define view entity zpbu_c_booking_m
  as projection on zpbu_i_booking_m
{
  key TravelId,
  key BookingId,
      BookingDate,
      CustomerId,
      CarrierId,
      ConnectionId,
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      CurrencyCode,
      BookingStatus,
      LastChangedAt,
      /* Associations */
      _bookingStatus,
      _booksuppl: redirected to composition child zpbu_c_booksuppl_m,
      _carrier,
      _connection,
      _customer,
      _travel: redirected to parent zpbu_c_travel_m
}

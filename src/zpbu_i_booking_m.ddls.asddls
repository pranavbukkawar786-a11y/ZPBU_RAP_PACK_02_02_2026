@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for booking m'
@Metadata.ignorePropagatedAnnotations: true
define view entity zpbu_i_booking_m
  as select from /dmo/booking_m
  association to parent ZPBU_i_TRAVEL_M    as _travel        on $projection.TravelId = _travel.TravelId
  composition [0..*] of zpbu_i_booksuppl_m as _booksuppl
  association to /DMO/I_Customer           as _customer      on $projection.CustomerId = _customer.CustomerID
  association to /DMO/I_Carrier            as _carrier       on $projection.CarrierId = _carrier.AirlineID
  association to /DMO/I_Connection         as _connection    on $projection.ConnectionId = _connection.ConnectionID
  association to /DMO/I_Booking_Status_VH  as _bookingStatus on $projection.BookingStatus = _bookingStatus.BookingStatus
{
  key travel_id       as TravelId,
  key booking_id      as BookingId,
      booking_date    as BookingDate,
      customer_id     as CustomerId,
      carrier_id      as CarrierId,
      connection_id   as ConnectionId,
      flight_date     as FlightDate,
      @Semantics.amount.currencyCode : 'CurrencyCode'
      flight_price    as FlightPrice,
      currency_code   as CurrencyCode,
      booking_status  as BookingStatus,
      last_changed_at as LastChangedAt,
      _travel,
      _booksuppl,
      _customer,
      _carrier,
      _connection,
      _bookingStatus
}

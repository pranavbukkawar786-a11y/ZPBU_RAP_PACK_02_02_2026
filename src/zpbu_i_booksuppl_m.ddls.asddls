@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for booking suppl'
@Metadata.ignorePropagatedAnnotations: true
define view entity zpbu_i_booksuppl_m
  as select from /dmo/booksuppl_m
  association to parent zpbu_i_booking_m as _booking   on  $projection.TravelId  = _booking.TravelId
                                                       and $projection.BookingId = _booking.BookingId
  association to ZPBU_i_TRAVEL_M         as _travel    on  $projection.TravelId = _travel.TravelId
  association to /DMO/I_Supplement       as _suppl     on  $projection.BookingSupplementId = _suppl.SupplementID
  association to /DMO/I_SupplementText   as _supplText on  $projection.SupplementId = _supplText.SupplementID
{
  key travel_id             as TravelId,
  key booking_id            as BookingId,
  key booking_supplement_id as BookingSupplementId,
      supplement_id         as SupplementId,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price                 as Price,
      currency_code         as CurrencyCode,
       @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at       as LastChangedAt,
      _booking,
      _travel,
      _suppl,
      _supplText
}

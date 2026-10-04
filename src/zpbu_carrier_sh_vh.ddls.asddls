@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'search help for field name field in booking'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
define view entity zpbu_carrier_SH_VH as select from /DMO/I_Carrier
{
    AirlineID,
    Name
}

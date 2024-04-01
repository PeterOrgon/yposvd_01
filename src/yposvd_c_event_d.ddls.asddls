@EndUserText.label: 'Event Projection with Draft'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true
@Search.searchable: true 
@ObjectModel.semanticKey: ['EventID']

define root view entity yposvd_c_event_d
  provider contract transactional_query
  as projection on yposvd_r_event
{
  key EventUUID,

      @Search.defaultSearchElement: true
      EventID,

      @Search.defaultSearchElement: true
      Name,

      Status,

      Description,

      LocalLastChangedAt,
      /* Associations */
      _Wishlist : redirected to composition child yposvd_c_wishlist_d
}

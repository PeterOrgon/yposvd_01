@EndUserText.label: 'Wishlist Projection with Draft'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: ['WishlistID']

define view entity yposvd_c_wishlist_d
  as projection on yposvd_r_wishlist
{
  key WishlistUUID,

      EventUUID,

      @Search.defaultSearchElement: true
      WishlistID,

      @Search.defaultSearchElement: true
      Name,
            
      Description,

      LocalLastChangedAt,

      /* Associations */
      _Event : redirected to parent yposvd_c_event_d,
      _Wish : redirected to composition child yposvd_c_wish_d
}

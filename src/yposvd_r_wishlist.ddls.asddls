@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Wishlist Base View'
define view entity yposvd_r_wishlist
  as select from yposvd_wishlist
  association to parent yposvd_r_event as _Event on $projection.EventUUID = _Event.EventUUID
  composition [0..*] of yposvd_r_wish  as _Wish
{
  key wishlist_uuid         as WishlistUUID,
      parent_uuid           as EventUUID,
      wishlist_id           as WishlistID,
      name                  as Name,
      description           as Description,

      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.lastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      //local ETag field --> OData ETag
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      //total ETag field
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,

      // Associations
      _Event,
      _Wish
}

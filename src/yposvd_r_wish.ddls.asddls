@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Wish Base View'
define view entity yposvd_r_wish
  as select from yposvd_wish
  association        to parent yposvd_r_wishlist as _Wishlist on $projection.WishlistUUID = _Wishlist.WishlistUUID
  association [1..1] to yposvd_r_event           as _Event    on $projection.EventUUID = _Event.EventUUID

  association [1..1] to yposvd_i_product         as _Product  on $projection.ProductID = _Product.ProductID
  association [1..1] to yposvd_i_person          as _Person   on $projection.PersonID = _Person.PersonID

{
  key wish_uuid             as WishUUID,
      root_uuid             as EventUUID,
      parent_uuid           as WishlistUUID,
      wish_id               as WishID,
      name                  as Name,
      description           as Description,
      product_id            as ProductID,
      person_id             as PersonID,

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
      _Wishlist,
      _Event,
      _Product,
      _Person
}

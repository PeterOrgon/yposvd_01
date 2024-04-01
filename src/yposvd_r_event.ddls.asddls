@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Event Base View'
define root view entity yposvd_r_event
  as select from yposvd_event
  composition [0..*] of yposvd_r_wishlist as _Wishlist
{
  key event_uuid            as EventUUID,
      event_id              as EventID,
      name                  as Name,
      status                as Status,
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
      _Wishlist
}

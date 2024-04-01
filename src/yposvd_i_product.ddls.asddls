@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Interface View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true

define view entity yposvd_i_product
  as select from yposvd_product
{
      @Search.defaultSearchElement: true
  key product_id      as ProductID,
      @Search.defaultSearchElement: true
      name            as Name,
      description     as Description,
      url             as Url,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      estimated_price as EstimatedPrice,
      currency_code   as CurrencyCode,
      @Semantics.user.createdBy: true
      created_by      as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at      as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt

}

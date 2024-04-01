@EndUserText.label: 'Wish Projection with Draft'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: ['WishID']

define view entity yposvd_c_wish_d
  as projection on yposvd_r_wish
{
  key WishUUID,

      EventUUID,

      WishlistUUID,

      @Search.defaultSearchElement: true
      WishID,


      @Search.defaultSearchElement: true
      Name,

      Description,

      @ObjectModel.text.element: ['ProductName']
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{entity: {name: 'yposvd_i_product_vh', element: 'ProductID' }, useForValidation: true}]
      ProductID,
      _Product.Name    as ProductName,
      
      @Consumption.valueHelpDefinition: [{entity: {name: 'yposvd_i_person_vh', element: 'PersonID' }, useForValidation: true}]        
      PersonID,
      _Person.FullName as PersonName,


      LocalLastChangedAt,

      /* Associations */
      _Wishlist : redirected to parent yposvd_c_wishlist_d,
      _Event    : redirected to yposvd_c_event_d,
      _Product,
      _Person
}

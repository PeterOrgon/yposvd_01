@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product ValueHelp'
@Search.searchable: true
@Consumption.valueHelpDefault.fetchValues: #AUTOMATICALLY_WHEN_DISPLAYED

define view entity yposvd_i_product_vh
  as select from yposvd_i_product
{      
      @ObjectModel.text.element: ['Name']
      @UI.textArrangement: #TEXT_SEPARATE
      @UI.lineItem: [{ position: 10, importance: #HIGH }]
  key ProductID,
      
      @UI.lineItem: [{ position: 20, importance: #HIGH, label: 'Name', type: #WITH_URL, url: 'NewWindowUrl'}]                 
      Name,
      
      @UI.hidden: true  
      Url,
      
      @UI.hidden: true 
      concat('javascript:window.open("', concat(Url, '")')) as NewWindowUrl,
                    
      @Semantics.amount.currencyCode: 'CurrencyCode'
      @UI.lineItem: [{ position: 30, importance: #HIGH, label: 'Estimated Price' }]
      EstimatedPrice,

      @UI.hidden: true
      CurrencyCode
}

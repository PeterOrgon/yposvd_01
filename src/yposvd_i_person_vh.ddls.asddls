@EndUserText.label: 'Person ValueHelp'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true

define view entity yposvd_i_person_vh
  as select from yposvd_i_person
{       
      @UI.textArrangement: #TEXT_SEPARATE
      @UI.lineItem: [{ position: 10, importance: #HIGH }]
  key PersonID,    
      @UI.lineItem: [{ position: 20, importance: #HIGH, label: 'Full Name' }]
      FullName

}

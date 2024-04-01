CLASS ycl_yposvd_test_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ycl_yposvd_test_data IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    DATA:
      lt_test_data_product TYPE STANDARD TABLE OF yposvd_product WITH EMPTY KEY,
      lt_test_data_person  TYPE STANDARD TABLE OF yposvd_person WITH EMPTY KEY.


    lt_test_data_product = VALUE #(
        ( product_id = '0000000001'  name = 'Topinkovac' description = 'Topinkova nejaky ...' url = 'https://www.google.com' estimated_price = '122' currency_code = 'EUR' )
        ( product_id = '0000000002' name = 'Robot' description = 'Robot makac miesac ...' url = 'https://www.bing.com' estimated_price = '445.67' currency_code = 'EUR' )
    ).

    DELETE FROM yposvd_product.
    INSERT yposvd_product FROM TABLE @lt_test_data_product.

    out->write( |yposvd_product: Datasets inserted { sy-dbcnt }| ).


    lt_test_data_person = VALUE #(
        ( person_id = '0000000001'  full_name = 'Host 1' )
        ( person_id = '0000000002'  full_name = 'Host 2' )
    ).

    DELETE FROM yposvd_person.
    INSERT yposvd_person FROM TABLE @lt_test_data_person.

    out->write( |yposvd_person: Datasets inserted { sy-dbcnt }| ).

    COMMIT WORK.
  ENDMETHOD.

ENDCLASS.

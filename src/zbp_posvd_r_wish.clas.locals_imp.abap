CLASS lhc_Wish DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS setWishNumber FOR DETERMINE ON SAVE
      IMPORTING keys FOR Wish~setWishNumber.
    METHODS validatePerson FOR VALIDATE ON SAVE
      IMPORTING keys FOR Wish~validatePerson.
    METHODS validateProduct FOR VALIDATE ON SAVE
      IMPORTING keys FOR Wish~validateProduct.

ENDCLASS.

CLASS lhc_Wish IMPLEMENTATION.

  METHOD setWishNumber.

    DATA max_wish_id TYPE yposvd_de_wish_id.
    DATA wishes_update TYPE TABLE FOR UPDATE yposvd_r_event\\Wish.

    "Read all wishlists for the requested wishes
    " If multiple wishes of the same wishlist are requested, the wishlist is returned only once.
    READ ENTITIES OF yposvd_r_event IN LOCAL MODE
      ENTITY Wish BY \_Wishlist
        FIELDS (  WishlistUUID  )
        WITH CORRESPONDING #( keys )
      RESULT DATA(wishlists).

    " Process all affected wishlists. Read respective wishes for one wishlist
    LOOP AT wishlists INTO DATA(ls_wishlist).
      READ ENTITIES OF yposvd_r_event IN LOCAL MODE
        ENTITY Wishlist BY \_Wish
          FIELDS ( WishID )
          WITH VALUE #( ( %tky = ls_wishlist-%tky ) )
        RESULT DATA(wishes).

      " Find max used WishlistID in all wishlists of this event
      max_wish_id = '0000000000'.
      LOOP AT wishes INTO DATA(wish).
        IF wish-WishID > max_wish_id.
          max_wish_id = wish-WishID.
        ENDIF.
      ENDLOOP.

      "Provide a WishID for all wishes of this wishlist that have none.
      LOOP AT wishes INTO wish WHERE WishID IS INITIAL.
        max_wish_id += 1.
        APPEND VALUE #( %tky                = wish-%tky
                        WishID = max_wish_id
                      ) TO wishes_update.

      ENDLOOP.
    ENDLOOP.

    " Provide a WishlistID for all wishes that have none.
    MODIFY ENTITIES OF yposvd_r_event IN LOCAL MODE
      ENTITY Wish
        UPDATE FIELDS ( WishID ) WITH wishes_update.

  ENDMETHOD.

  METHOD validatePerson.

    READ ENTITIES OF yposvd_r_event IN LOCAL MODE
    ENTITY Wish
      FIELDS ( WishID PersonID )
      WITH CORRESPONDING #(  keys )
    RESULT DATA(wishes)
    FAILED DATA(read_failed).

    failed = CORRESPONDING #( DEEP read_failed ).

    READ ENTITIES OF yposvd_r_event IN LOCAL MODE
      ENTITY Wish BY \_Wishlist
        FROM CORRESPONDING #( wishes )
      LINK DATA(wishes_wishlist_links).

    READ ENTITIES OF yposvd_r_event IN LOCAL MODE
      ENTITY Wish BY \_Event
        FROM CORRESPONDING #( wishes )
      LINK DATA(wishes_event_links).
*
*
*    DATA persons TYPE SORTED TABLE OF yposvd_person WITH UNIQUE KEY person_id.
*
*    " Optimization of DB select: extract distinct non-initial person IDs
*    persons = CORRESPONDING #( wishes DISCARDING DUPLICATES MAPPING person_id = PersonID EXCEPT * ).
*    DELETE persons WHERE person_id IS INITIAL.
*
*    IF persons IS NOT INITIAL.
*      " Check if person ID exists
*      SELECT FROM yposvd_i_person FIELDS PersonID
*                                  FOR ALL ENTRIES IN @persons
*                                  WHERE PersonID = @persons-person_id
*      INTO TABLE @DATA(valid_persons).
*    ENDIF.
*
*    LOOP AT wishes ASSIGNING FIELD-SYMBOL(<wish>).
*
*      APPEND VALUE #(  %tky        = <wish>-%tky
*                       %state_area = 'VALIDATE_PERSON'
*                    ) TO reported-wish.
*
*      IF <wish>-PersonID IS  INITIAL.
*        APPEND VALUE #( %tky = <wish>-%tky ) TO failed-wish.
*
*        APPEND VALUE #( %tky                  = <wish>-%tky
*                        %state_area           = 'VALIDATE_PERSON'
*                        %msg                  = NEW ycm_yposvd_messages(
*                                                                textid = ycm_yposvd_messages=>person_unkown
*                                                                severity = if_abap_behv_message=>severity-error )
*                        %path                 = VALUE #( wishlist-%tky = wishes_wishlist_links[ KEY id  source-%tky = <wish>-%tky ]-target-%tky
*                                                         event-%tky  = wishes_event_links[  KEY id  source-%tky = <wish>-%tky ]-target-%tky )
*                        %element-PersonID = if_abap_behv=>mk-on
*                       ) TO reported-wish.
*
*
*      ELSEIF <wish>-PersonID IS NOT INITIAL AND NOT line_exists( valid_persons[ PersonID = <wish>-PersonID ] ).
*        APPEND VALUE #(  %tky = <wish>-%tky ) TO failed-wish.
*
*        APPEND VALUE #( %tky                  = <wish>-%tky
*                        %state_area           = 'VALIDATE_PERSON'
*                        %msg                  = NEW ycm_yposvd_messages(
*                                                                textid = ycm_yposvd_messages=>person_unkown
*                                                                severity = if_abap_behv_message=>severity-error )
*                        %path                 = VALUE #( wishlist-%tky = wishes_wishlist_links[ KEY id  source-%tky = <wish>-%tky ]-target-%tky
*                                                         event-%tky = wishes_event_links[  KEY id  source-%tky = <wish>-%tky ]-target-%tky )
*                        %element-PersonID = if_abap_behv=>mk-on
*                       ) TO reported-wish.
*      ENDIF.
*
*    ENDLOOP.

  ENDMETHOD.

  METHOD validateProduct.

    READ ENTITIES OF yposvd_r_event IN LOCAL MODE
    ENTITY Wish
      FIELDS ( WishID )
      WITH CORRESPONDING #(  keys )
    RESULT DATA(wishes)
    FAILED DATA(read_failed).

    failed = CORRESPONDING #( DEEP read_failed ).

    READ ENTITIES OF yposvd_r_event IN LOCAL MODE
      ENTITY Wish BY \_Wishlist
        FROM CORRESPONDING #( wishes )
      LINK DATA(wishes_wishlist_links).

    READ ENTITIES OF yposvd_r_event IN LOCAL MODE
      ENTITY Wish BY \_Event
        FROM CORRESPONDING #( wishes )
      LINK DATA(wishes_event_links).


    DATA products TYPE SORTED TABLE OF yposvd_product WITH UNIQUE KEY product_id.
*
*    " Optimization of DB select: extract distinct non-initial product IDs
*    products = CORRESPONDING #( wishes DISCARDING DUPLICATES MAPPING product_id = ProductID EXCEPT * ).
*    DELETE products WHERE product_id IS INITIAL.
*
*    IF products IS NOT INITIAL.
*      " Check if product ID exists
*      SELECT FROM yposvd_i_product FIELDS ProductID
*                                  FOR ALL ENTRIES IN @products
*                                  WHERE ProductID = @products-product_id
*      INTO TABLE @DATA(valid_products).
*    ENDIF.
*
*    LOOP AT wishes ASSIGNING FIELD-SYMBOL(<wish>).
*
*      APPEND VALUE #(  %tky        = <wish>-%tky
*                       %state_area = 'VALIDATE_PRODUCT'
*                    ) TO reported-wish.
*
*      IF <wish>-ProductID IS  INITIAL.
*        APPEND VALUE #( %tky = <wish>-%tky ) TO failed-wish.
*
*        APPEND VALUE #( %tky                  = <wish>-%tky
*                        %state_area           = 'VALIDATE_PRODUCT'
*                        %msg                  = NEW ycm_yposvd_messages(
*                                                                textid = ycm_yposvd_messages=>product_unkown
*                                                                severity = if_abap_behv_message=>severity-error )
*                        %path                 = VALUE #( wishlist-%tky = wishes_wishlist_links[ KEY id  source-%tky = <wish>-%tky ]-target-%tky
*                                                         event-%tky  = wishes_event_links[  KEY id  source-%tky = <wish>-%tky ]-target-%tky )
*                        %element-ProductID = if_abap_behv=>mk-on
*                       ) TO reported-wish.
*
*
*      ELSEIF <wish>-ProductID IS NOT INITIAL AND NOT line_exists( valid_products[ ProductID = <wish>-ProductID ] ).
*        APPEND VALUE #(  %tky = <wish>-%tky ) TO failed-wish.
*
*        APPEND VALUE #( %tky                  = <wish>-%tky
*                        %state_area           = 'VALIDATE_PRODUCT'
*                        %msg                  = NEW ycm_yposvd_messages(
*                                                                textid = ycm_yposvd_messages=>product_unkown
*                                                                severity = if_abap_behv_message=>severity-error )
*                        %path                 = VALUE #( wishlist-%tky = wishes_wishlist_links[ KEY id  source-%tky = <wish>-%tky ]-target-%tky
*                                                         event-%tky = wishes_event_links[  KEY id  source-%tky = <wish>-%tky ]-target-%tky )
*                        %element-ProductID = if_abap_behv=>mk-on
*                       ) TO reported-wish.
*      ENDIF.
*
*    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

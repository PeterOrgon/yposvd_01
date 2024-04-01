CLASS lhc_Wishlist DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS setWishlistNumber FOR DETERMINE ON SAVE
      IMPORTING keys FOR Wishlist~setWishlistNumber.

ENDCLASS.

CLASS lhc_Wishlist IMPLEMENTATION.

  METHOD setWishlistNumber.

    DATA max_wishlist_id TYPE YPOSVD_DE_WISHLIST_ID.
    DATA wishlists_update TYPE TABLE FOR UPDATE yposvd_r_event\\Wishlist.

    "Read all events for the requested wishlist
    " If multiple wishlists of the same event are requested, the event is returned only once.
    READ ENTITIES OF yposvd_r_event IN LOCAL MODE
      ENTITY Wishlist BY \_Event
        FIELDS ( EventUUID )
        WITH CORRESPONDING #( keys )
      RESULT DATA(events).

    " Process all affected events. Read respective wishlists for one travel
    LOOP AT events INTO DATA(event).
      READ ENTITIES OF yposvd_r_event IN LOCAL MODE
        ENTITY Event BY \_Wishlist
          FIELDS ( WishlistID )
          WITH VALUE #( ( %tky = event-%tky ) )
        RESULT DATA(wishlists).

      " Find max used WishlistID in all wishlists of this event
      max_wishlist_id = '0000000000'.
      LOOP AT wishlists INTO DATA(wishlist).
        IF wishlist-WishlistID > max_wishlist_id.
          max_wishlist_id = wishlist-WishlistID.
        ENDIF.
      ENDLOOP.

      " Provide a WishlistID for all wishlists of this event that have none.
      LOOP AT wishlists INTO wishlist WHERE WishlistID IS INITIAL.
        max_wishlist_id += 1.
        APPEND VALUE #( %tky      = wishlist-%tky
                        WishlistID = max_wishlist_id
                      ) TO wishlists_update.

      ENDLOOP.
    ENDLOOP.

    " Provide a WishlistID for all bookings that have none.
    MODIFY ENTITIES OF yposvd_r_event IN LOCAL MODE
      ENTITY Wishlist
        UPDATE FIELDS ( WishlistID )
        WITH wishlists_update.


  ENDMETHOD.

ENDCLASS.

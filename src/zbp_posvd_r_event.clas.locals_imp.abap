CLASS lhc_Event DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Event RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Event RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Event RESULT result.

    METHODS activateEvent FOR MODIFY
      IMPORTING keys FOR ACTION Event~activateEvent RESULT result.

    METHODS cancelEvent FOR MODIFY
      IMPORTING keys FOR ACTION Event~cancelEvent RESULT result.
    METHODS setEventNumber FOR DETERMINE ON SAVE
      IMPORTING keys FOR Event~setEventNumber.
    METHODS setStatusToNew FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Event~setStatusToNew.

ENDCLASS.

CLASS lhc_Event IMPLEMENTATION.

  METHOD get_instance_features.

  READ ENTITIES OF yposvd_r_event IN LOCAL MODE
      ENTITY Event
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(events)
      FAILED failed.


    result = VALUE #( FOR ls_event IN events
                          ( %tky                   = ls_event-%tky
                            %action-activateEvent   = COND #( WHEN ls_event-Status = 'N'
                                                             THEN if_abap_behv=>fc-o-enabled
                                                             ELSE if_abap_behv=>fc-o-disabled )
                            %action-cancelEvent   = COND #( WHEN ls_event-Status = 'A'
                                                             THEN if_abap_behv=>fc-o-enabled
                                                             ELSE if_abap_behv=>fc-o-disabled )
                            %assoc-_Wishlist        = COND #( WHEN ls_event-Status = 'A'
                                                            THEN if_abap_behv=>fc-o-enabled
                                                            ELSE if_abap_behv=>fc-o-disabled )
                          ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD activateEvent.

    "Modify Event instance
    MODIFY ENTITIES OF yposvd_r_event IN LOCAL MODE
      ENTITY Event
        UPDATE FIELDS ( Status )
        WITH VALUE #( FOR key IN keys ( %tky   = key-%tky
                                        Status = 'A' ) ).

    "Read changed data for action result
    READ ENTITIES OF yposvd_r_event IN LOCAL MODE
      ENTITY Event
        ALL FIELDS WITH
        CORRESPONDING #( keys )
      RESULT DATA(events).

    result = VALUE #( FOR event IN events ( %tky   = event-%tky
                                            %param = event ) ).

  ENDMETHOD.

  METHOD cancelEvent.

    "Modify Event instance
    MODIFY ENTITIES OF yposvd_r_event IN LOCAL MODE
      ENTITY Event
        UPDATE FIELDS ( Status )
        WITH VALUE #( FOR key IN keys ( %tky   = key-%tky
                                        Status = 'C' ) ).

    "Read changed data for action result
    READ ENTITIES OF yposvd_r_event IN LOCAL MODE
      ENTITY Event
        ALL FIELDS WITH
        CORRESPONDING #( keys )
      RESULT DATA(events).

    result = VALUE #( FOR event IN events ( %tky   = event-%tky
                                            %param = event ) ).

  ENDMETHOD.

  METHOD setEventNumber.

    "Ensure idempotency
    READ ENTITIES OF yposvd_r_event IN LOCAL MODE
      ENTITY Event
        FIELDS ( EventID )
        WITH CORRESPONDING #( keys )
      RESULT DATA(events).

    DELETE events WHERE EventID IS NOT INITIAL.
    CHECK events IS NOT INITIAL.

    "Get max travelID
    SELECT SINGLE FROM yposvd_event FIELDS MAX( event_id ) INTO @DATA(max_event_id).

    "update involved instances
    MODIFY ENTITIES OF yposvd_r_event IN LOCAL MODE
      ENTITY Event
        UPDATE FIELDS ( EventID )
        WITH VALUE #( FOR event IN events INDEX INTO i (
                           %tky     = event-%tky
                           EventID  = max_event_id + i ) ).

  ENDMETHOD.

  METHOD setStatusToNew.

    READ ENTITIES OF yposvd_r_event IN LOCAL MODE
   ENTITY Event
     FIELDS ( Status )
     WITH CORRESPONDING #( keys )
   RESULT DATA(events).

    "If Status is already set, do nothing
    DELETE events WHERE Status IS NOT INITIAL.
    CHECK events IS NOT INITIAL.

    MODIFY ENTITIES OF yposvd_r_event IN LOCAL MODE
      ENTITY Event
        UPDATE FIELDS ( Status )
        WITH VALUE #( FOR event IN events ( %tky   = event-%tky
                                            Status = 'N' ) ).

  ENDMETHOD.

ENDCLASS.

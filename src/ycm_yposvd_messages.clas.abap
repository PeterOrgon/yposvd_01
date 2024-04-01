CLASS ycm_yposvd_messages DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .
    INTERFACES if_abap_behv_message .

    CONSTANTS:
      gc_msgid TYPE symsgid VALUE 'YPOSVD_MESSAGES',

      BEGIN OF product_unkown,
        msgid TYPE symsgid VALUE gc_msgid,
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'MV_PRODUCT_ID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF product_unkown,

      BEGIN OF person_unkown,
        msgid TYPE symsgid VALUE gc_msgid,
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'MV_PERSON_ID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF person_unkown.

    METHODS constructor
      IMPORTING
        textid      LIKE if_t100_message=>t100key OPTIONAL
        attr1       TYPE string OPTIONAL
        attr2       TYPE string OPTIONAL
        attr3       TYPE string OPTIONAL
        attr4       TYPE string OPTIONAL
        previous    LIKE previous OPTIONAL
        event_id    TYPE yposvd_de_event_id OPTIONAL
        wishlist_id TYPE yposvd_de_wishlist_id OPTIONAL
        wish_id     TYPE yposvd_de_wish_id OPTIONAL
        product_id  TYPE yposvd_de_product_id OPTIONAL
        person_id   TYPE yposvd_de_person_id OPTIONAL
        severity    TYPE if_abap_behv_message=>t_severity OPTIONAL
        uname       TYPE syuname OPTIONAL.

    DATA:
      mv_attr1       TYPE string,
      mv_attr2       TYPE string,
      mv_attr3       TYPE string,
      mv_attr4       TYPE string,
      mv_event_id    TYPE yposvd_de_event_id,
      mv_wishlist_id TYPE yposvd_de_wishlist_id,
      mv_wish_id     TYPE yposvd_de_wish_id,
      mv_product_id  TYPE yposvd_de_product_id,
      mv_person_id   TYPE yposvd_de_person_id,
      mv_uname       TYPE syuname.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ycm_yposvd_messages IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor(  previous = previous ) .

    me->mv_attr1                    = attr1.
    me->mv_attr2                    = attr2.
    me->mv_attr3                    = attr3.
    me->mv_attr4                    = attr4.
    me->mv_event_id                 = event_id.
    me->mv_wishlist_id              = wishlist_id.
    me->mv_wish_id                  = wish_id.
    me->mv_product_id               = product_id.
    me->mv_person_id                = person_id.
    me->mv_uname                    = uname.


    if_abap_behv_message~m_severity = severity.

    CLEAR me->textid.

    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

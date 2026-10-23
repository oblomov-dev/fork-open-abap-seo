CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS seo_implem_global FOR TESTING.
    METHODS seo_implem_caller_types FOR TESTING.
    METHODS seo_implem_none FOR TESTING.
    METHODS seo_implem_not_existing FOR TESTING.
    METHODS seo_implem_is_class FOR TESTING.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD seo_implem_global.
* IF_MESSAGE is implemented by CX_ROOT, so every exception class is an
* implementer, the interfaces of a superclass counting as on a system
    DATA ls_key  TYPE seoclskey.
    DATA lt_impl TYPE seor_implementing_keys.
    DATA ls_impl LIKE LINE OF lt_impl.

    ls_key-clsname = 'IF_MESSAGE'.
    CALL FUNCTION 'SEO_INTERFACE_IMPLEM_GET_ALL'
      EXPORTING
        intkey       = ls_key
      IMPORTING
        impkeys      = lt_impl
      EXCEPTIONS
        not_existing = 1
        OTHERS       = 2.
    cl_abap_unit_assert=>assert_subrc( ).

    READ TABLE lt_impl INTO ls_impl WITH KEY clsname = 'CX_ROOT'.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_impl-refclsname
      exp = 'IF_MESSAGE' ).

    READ TABLE lt_impl TRANSPORTING NO FIELDS WITH KEY clsname = 'CX_SY_ZERODIVIDE'.
    cl_abap_unit_assert=>assert_subrc( ).

    READ TABLE lt_impl TRANSPORTING NO FIELDS WITH KEY clsname = 'CL_SEO_IMPLEM_TEST'.
    cl_abap_unit_assert=>assert_subrc( exp = 4 ).

* the interface itself is not an implementer
    READ TABLE lt_impl TRANSPORTING NO FIELDS WITH KEY clsname = 'IF_MESSAGE'.
    cl_abap_unit_assert=>assert_subrc( exp = 4 ).
  ENDMETHOD.

  METHOD seo_implem_caller_types.
* a caller without the SEO types passes its own one-field key and its own
* row type, type-compatible with the formal parameters on a system
    TYPES BEGIN OF ty_s_key.
    TYPES intkey TYPE c LENGTH 30.
    TYPES END OF ty_s_key.
    TYPES BEGIN OF ty_s_impl.
    TYPES clsname TYPE c LENGTH 30.
    TYPES END OF ty_s_impl.
    DATA ls_key  TYPE ty_s_key.
    DATA lt_impl TYPE STANDARD TABLE OF ty_s_impl WITH DEFAULT KEY.

    ls_key-intkey = 'if_message'.
    CALL FUNCTION 'SEO_INTERFACE_IMPLEM_GET_ALL'
      EXPORTING
        intkey       = ls_key
      IMPORTING
        impkeys      = lt_impl
      EXCEPTIONS
        not_existing = 1
        OTHERS       = 2.
    cl_abap_unit_assert=>assert_subrc( ).

    READ TABLE lt_impl TRANSPORTING NO FIELDS WITH KEY clsname = 'CX_ROOT'.
    cl_abap_unit_assert=>assert_subrc( ).
  ENDMETHOD.

  METHOD seo_implem_none.
    DATA ls_key  TYPE seoclskey.
    DATA lt_impl TYPE seor_implementing_keys.

    ls_key-clsname = 'IF_AMDP_MARKER_HDB'.
    CALL FUNCTION 'SEO_INTERFACE_IMPLEM_GET_ALL'
      EXPORTING
        intkey       = ls_key
      IMPORTING
        impkeys      = lt_impl
      EXCEPTIONS
        not_existing = 1
        OTHERS       = 2.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_initial( lt_impl ).
  ENDMETHOD.

  METHOD seo_implem_not_existing.
    DATA ls_key  TYPE seoclskey.
    DATA lt_impl TYPE seor_implementing_keys.

    ls_key-clsname = 'SDFSDFSD'.
    CALL FUNCTION 'SEO_INTERFACE_IMPLEM_GET_ALL'
      EXPORTING
        intkey       = ls_key
      IMPORTING
        impkeys      = lt_impl
      EXCEPTIONS
        not_existing = 1
        is_class     = 2
        OTHERS       = 3.
    cl_abap_unit_assert=>assert_equals(
      exp = 1
      act = sy-subrc ).
  ENDMETHOD.

  METHOD seo_implem_is_class.
    DATA ls_key  TYPE seoclskey.
    DATA lt_impl TYPE seor_implementing_keys.

    ls_key-clsname = 'CL_ABAP_UNIT_ASSERT'.
    CALL FUNCTION 'SEO_INTERFACE_IMPLEM_GET_ALL'
      EXPORTING
        intkey       = ls_key
      IMPORTING
        impkeys      = lt_impl
      EXCEPTIONS
        not_existing = 1
        is_class     = 2
        OTHERS       = 3.
    cl_abap_unit_assert=>assert_equals(
      exp = 2
      act = sy-subrc ).
  ENDMETHOD.

ENDCLASS.
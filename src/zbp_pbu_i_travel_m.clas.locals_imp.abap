CLASS lhc_ZPBU_i_TRAVEL_M DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR ZPBU_i_TRAVEL_M RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR ZPBU_i_TRAVEL_M RESULT result.
    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
       keys FOR Travel~calculateTotalPrice.
    METHODS earlynumbering_create FOR NUMBERING
       entities FOR CREATE Travel.

ENDCLASS.

CLASS lhc_ZPBU_i_TRAVEL_M IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.
    DATA(it_entity_no_travel_id) = entities.

    DELETE it_entity_no_travel_id WHERE TravelId IS NOT INITIAL.
    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
            nr_range_nr       = '01'
            object            = '/DMO/TRV_M'
            quantity          = CONV #( lines( it_entity_no_travel_id ) )
        IMPORTING
          number            = DATA(lv_returned_number)
          returncode        = DATA(lv_return_code)
          returned_quantity = DATA(lv_returned_qty)
        ).
      CATCH cx_nr_object_not_found.
      CATCH cx_number_ranges INTO DATA(ix_number_range).

        LOOP AT it_entity_no_travel_id INTO DATA(ls_entity_no_travel_id).
          APPEND VALUE #( %cid = ls_entity_no_travel_id-%cid
                          %key = ls_entity_no_travel_id-%key ) TO failed-travel.

          APPEND VALUE #( %cid = ls_entity_no_travel_id-%cid
                          %key = ls_entity_no_travel_id-%key
                          %msg = ix_number_range ) TO reported-travel.
        ENDLOOP.

        EXIT.
    ENDTRY.
    " TO CHECK EXACT NUMBERS ARE FETCHED OR NOT. LIKE CHECK STATEMENT

    ASSERT lv_returned_qty = lines( it_entity_no_travel_id ).

** 4158 -- cURRECT NUMBER --> 4159 --> 4160 --> 4161 --> 3

    DATA(lv_currect_number) = lv_returned_number + 1 .

    LOOP AT it_entity_no_travel_id INTO ls_entity_no_travel_id.

      lv_currect_number = lv_currect_number + 1.

      APPEND VALUE #( %cid = ls_entity_no_travel_id-%cid
      travelid = lv_currect_number ) TO mapped-travel.
    ENDLOOP.
  ENDMETHOD.
  METHOD calculateTotalPrice.

    TYPES: BEGIN OF lty_price,
             amount       TYPE /dmo/flight_price,
             currencyCode TYPE /dmo/currency_code,
           END OF lty_price.

    DATA: lt_price       TYPE TABLE OF lty_price,
          lv_totalAmount TYPE /dmo/flight_price.


    READ ENTITIES OF ZPBU_i_TRAVEL_M IN LOCAL MODE
    ENTITY Travel
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    READ ENTITIES OF ZPBU_i_TRAVEL_M IN LOCAL MODE
    ENTITY Travel BY \_booking
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_booking).

    LOOP AT lt_booking INTO DATA(ls_booking).

      COLLECT VALUE lty_price( amount = ls_booking-FlightPrice
                               currencycode = ls_booking-CurrencyCode
         ) INTO lt_price.

    ENDLOOP.

    DATA(ls_travel) = VALUE #( lt_travel[ 1 ] OPTIONAL ).
    LOOP AT lt_price INTO DATA(ls_price).

      IF ls_travel-CurrencyCode = ls_price-currencycode.
        "just copy pass
        lv_totalAmount = lv_totalAmount + ls_price-amount.

      ELSE.
        "convert AMDP class for currency conversions,
        /dmo/cl_flight_amdp=>convert_currency(
          EXPORTING
            iv_amount               = ls_price-amount
            iv_currency_code_source = ls_price-currencycode
            iv_currency_code_target = ls_travel-CurrencyCode
            iv_exchange_rate_date   = cl_abap_context_info=>get_system_date( )
          IMPORTING
            ev_amount               = DATA(lv_converted_amount)
        ).

        lv_totalAmount = lv_totalAmount + lv_converted_amount.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<lfs_travel>).

      CLEAR <lfs_travel>-TotalPrice.
      <lfs_travel>-TotalPrice =  lv_totalAmount.

    ENDLOOP.
    IF <lfs_travel> IS ASSIGNED.
      UNASSIGN <lfs_travel>.
    ENDIF.

    "after all calculations update Zpbu_i_travel_M-totalPrice
    MODIFY ENTITIES OF ZPBU_i_TRAVEL_M IN LOCAL MODE
    ENTITY Travel
    UPDATE FIELDS ( TotalPrice )
    WITH CORRESPONDING #( lt_travel ).


    IF 1 = 2.

    ENDIF.

  ENDMETHOD.

ENDCLASS.





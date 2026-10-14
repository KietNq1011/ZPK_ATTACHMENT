CLASS zcl_attachment_dmo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    " copy ZCL_ATTACHMENT, chỉ giữ delete_attachment
    " (create_attachment render PDF qua ADS + ZCL_FP_TMPL_STORE_CLIENT, TRIAL không có)
    METHODS delete_attachment
      IMPORTING i_appid        TYPE string
                i_moduleobject TYPE string
                i_documentid   TYPE zde_document_id_dmo.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_attachment_dmo IMPLEMENTATION.


  METHOD delete_attachment.
    SELECT DISTINCT uuid
     FROM zr_attachment_dmo
     INNER JOIN zi_attachment_i_dmo ON zr_attachment_dmo~uuid = zi_attachment_i_dmo~attachmentid
     WHERE zr_attachment_dmo~appid        = @i_appid
       AND zr_attachment_dmo~moduleobject = @i_moduleobject
       AND zi_attachment_i_dmo~documentid = @i_documentid
     INTO TABLE @DATA(lt_att).

    IF lt_att IS INITIAL.
      RETURN.
    ENDIF.

    MODIFY ENTITIES OF zr_attachment_dmo
    ENTITY attachment
    DELETE FROM VALUE #( FOR ls_att IN lt_att ( uuid = ls_att-uuid ) ).
  ENDMETHOD.
ENDCLASS.

CLASS lhc_attachment DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR attachment RESULT result.

    METHODS earlynumbering_cba_attachmenti FOR NUMBERING
      IMPORTING entities FOR CREATE attachment\_attachmentitem.

ENDCLASS.

CLASS lhc_attachment IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_cba_attachmenti.
    " item lấy key (AttachmentId, ModuleObject, AppId) từ header — như ZBP_R_ATTACHMENT
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entity>).

      READ ENTITIES OF zr_attachment_dmo IN LOCAL MODE
      ENTITY attachment
      ALL FIELDS WITH VALUE #( ( uuid = <ls_entity>-uuid ) )
      RESULT DATA(lt_attachment).

      CHECK lt_attachment IS NOT INITIAL.
      DATA(ls_attachment) = lt_attachment[ 1 ].

      LOOP AT <ls_entity>-%target ASSIGNING FIELD-SYMBOL(<ls_attach_item>).
        APPEND VALUE #( %cid         = <ls_attach_item>-%cid
                        %is_draft    = <ls_attach_item>-%is_draft
                        attachmentid = ls_attachment-uuid
                        moduleobject = ls_attachment-moduleobject
                        appid        = ls_attachment-appid
                        documentid   = <ls_attach_item>-documentid )
               TO mapped-attachmentitem.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

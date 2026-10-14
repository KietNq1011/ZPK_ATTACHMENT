# ZPK_ATTACHMENT

Bộ lưu file đính kèm dùng chung cho RAP (ABAP Cloud), copy từ package `ZATTACHMENT` (ZFPT_FUNCTION, NFG_CUS) để dùng trên BTP TRIAL cho demo xuất Excel `ZPK_XLSX_DEMO`. App lưu file theo khuôn ZWM13A / ZWM15: mỗi file là 1 bản ghi header + item `DocumentId`, tra lại bằng view có tham số `(module, app)`.

Mọi tên có hậu tố `_DMO` vì TRIAL là hệ thống dùng chung (`ZI_ATTACHMENT`, `ZDE_ATTACHMENT` đã thuộc package khác).

## Objects

| Object | Loại | Ghi chú |
|---|---|---|
| `ZDO_MODULE_OBJ_DMO` / `ZDE_MODULE_OBJECT_DMO` | DOMA / DTEL | CHAR 10 |
| `ZDE_APP_ID_DMO` | DTEL | CHAR 30 |
| `ZDE_DOCUMENT_ID_DMO` | DTEL | CHAR 30 |
| `ZDO_NOTE_DMO` / `ZDE_NOTE_DMO` | DOMA / DTEL | SSTRING 1333 |
| `ZDE_ATTACHMENT_DMO` | DTEL | RAWSTRING |
| `ZTB_ATT_DMO` / `ZTB_ATT_D_DMO` | TABL | header + draft |
| `ZTB_ATT_I_DMO` / `ZTB_ATT_ID_DMO` | TABL | item + draft |
| `ZR_ATTACHMENT_DMO` | DDLS + BDEF | root, managed + draft, UUID managed numbering |
| `ZI_ATTACHMENT_I_DMO` | DDLS | item (composition), early numbering lấy key từ header |
| `ZI_ATTACHMENT_DMO( p_module_obj, p_app_id )` | DDLS | view tra file theo `DocumentId` — dùng để LEFT JOIN vào root view của app |
| `ZBP_R_ATTACHMENT_DMO` | CLAS | behavior pool |
| `ZCL_ATTACHMENT_DMO` | CLAS | `delete_attachment( i_appid, i_moduleobject, i_documentid )` |

## Cài lên hệ thống

1. Tạo package `ZPK_ATTACHMENT` (Eclipse ADT).
2. abapGit Repositories → Link repo này vào package → Pull → activate.

## Dùng trong app (ví dụ ZPK_XLSX_DEMO)

Root view:

```abap
left outer join ZI_ATTACHMENT_DMO( p_module_obj: 'DMO', p_app_id: 'ZXLSX_DEMO' ) as File
  on File.DocumentId = cast( Travel.travel_id as zde_document_id_dmo )
```

Action (trong behavior handler, không COMMIT):

```abap
NEW zcl_attachment_dmo( )->delete_attachment( i_appid        = 'ZXLSX_DEMO'
                                              i_moduleobject = 'DMO'
                                              i_documentid   = lv_documentid ).

MODIFY ENTITIES OF zr_attachment_dmo
       ENTITY attachment
       CREATE FIELDS ( moduleobject appid attachment filename mimetype )
       WITH VALUE #( ( %cid = 'H1' moduleobject = 'DMO' appid = 'ZXLSX_DEMO'
                       attachment = lv_xlsx filename = lv_name mimetype = lv_mime ) )
       ENTITY attachment
       CREATE BY \_attachmentitem
       FIELDS ( documentid )
       WITH VALUE #( ( %cid_ref = 'H1'
                       %target  = VALUE #( ( %cid = 'I1' documentid = lv_documentid ) ) ) )
       FAILED DATA(ls_failed).
```

## Khác bản gốc ZATTACHMENT

- Bỏ `@ObjectModel.sapObjectNodeType.name: 'ZATTACHMENT'` và `extensible` (TRIAL không có SAP object type ZATTACHMENT).
- `ZR_ATTACHMENT_DMO` dùng `@AccessControl.authorizationCheck: #NOT_REQUIRED`, không DCL (bản gốc `#MANDATORY` + DCL `where TRUE`).
- Bảng item không khai foreign key sang header (bản gốc có, `screenCheck: false`).
- `ZCL_ATTACHMENT_DMO` chỉ có `delete_attachment` (thêm `SELECT DISTINCT`); `create_attachment` bản gốc render PDF qua ADS + `ZCL_FP_TMPL_STORE_CLIENT`.
- Không có `ZC_ATTACHMENT*`, DDLX, service `ZUI_ATTACHMENT_O4`.

## Trạng thái

File abapGit viết tay từ source export (chưa serialize từ hệ thống), chưa pull/activate thử trên TRIAL. Lỗi khi pull → báo lại để sửa XML.

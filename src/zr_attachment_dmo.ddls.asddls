@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Attachment (copy ZR_ATTACHMENT)'

@Metadata.allowExtensions: true

define root view entity ZR_ATTACHMENT_DMO
  as select from ztb_att_dmo as ATTACHMENT

  composition [1..*] of ZI_ATTACHMENT_I_DMO as _AttachmentItem

{
  key uuid                  as UUID,

      module_object         as ModuleObject,
      app_id                as AppID,
      attachment            as Attachment,
      filename              as Filename,
      mimetype              as Mimetype,
      note                  as Note,

      @Semantics.user.createdBy: true
      created_by            as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,

      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,

      _AttachmentItem
}

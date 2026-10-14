@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Attachment Item (copy ZI_ATTACHMENT_I)'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define view entity ZI_ATTACHMENT_I_DMO
  as select from ztb_att_i_dmo
  association to parent ZR_ATTACHMENT_DMO as _Attachment on $projection.AttachmentId = _Attachment.UUID

{
  key attachment_id         as AttachmentId,
  key module_object         as ModuleObject,
  key app_id                as AppId,
  key document_id           as DocumentId,

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

      _Attachment

}

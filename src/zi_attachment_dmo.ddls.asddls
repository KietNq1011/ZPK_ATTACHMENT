@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Attachment w. Param (copy ZI_ATTACHMENT)'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define view entity ZI_ATTACHMENT_DMO
  with parameters
    p_module_obj : zde_module_object_dmo,
    p_app_id     : zde_app_id_dmo

  as select from ZR_ATTACHMENT_DMO

  association [1..*] to ZI_ATTACHMENT_I_DMO as _AttachmentItem
    on  _AttachmentItem.AttachmentId = $projection.AttachmentId
    and _AttachmentItem.ModuleObject = $projection.ModuleObject
    and _AttachmentItem.AppId        = $projection.AppID

{
  key UUID                        as AttachmentId,
  key ModuleObject,
  key AppID,
  key _AttachmentItem.DocumentId,

      Attachment,
      Filename,
      Mimetype,
      Note,
      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,

      /* Associations */
      _AttachmentItem
}

where ModuleObject = $parameters.p_module_obj
  and AppID        = $parameters.p_app_id

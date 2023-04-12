page 50004 "NAB - Pstd. Purchase Invoices"
{
    PageType = API;
    APIVersion = 'v1.0';
    APIPublisher = 'nabsolutions';
    APIGroup = 'demo';

    EntityCaption = 'pstdPurchaseInvoice';
    EntitySetCaption = 'pstdPurchaseInvoices';
    EntityName = 'pstdPurchaseInvoice';
    EntitySetName = 'pstdPurchaseInvoices';

    ODataKeyFields = SystemId;
    SourceTable = "Purch. Inv. Header";
    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Extensible = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'id', Locked = true;
                    Editable = false;
                }
                field(number; Rec."No.")
                {
                    Caption = 'number', Locked = true;
                    Editable = false;
                }
                field(draftId; Rec."Draft Invoice SystemId")
                {
                    Caption = 'draftId', Locked = true;
                    Editable = false;
                }
                part(attachments; 50003)
                {
                    Caption = 'Attachments', Locked = true;
                    EntityName = 'nabAttachment';
                    EntitySetName = 'nabAttachments';
                    SubPageLink = "Document Id" = FIELD("Draft Invoice SystemId"),
#pragma warning disable AL0603
                                  "Document Type" = CONST(6);
#pragma warning restore AL0603
                }
            }
        }
    }

    actions
    {
    }
}
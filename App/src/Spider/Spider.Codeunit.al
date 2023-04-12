codeunit 50004 "NAB Spider"
{
    [EventSubscriber(ObjectType::Page, Page::"QWESR API - Sales Orders", 'OnGetExtraValues', '', false, false)]
    local procedure OnGetExtraValues(SalesOrderEntityBuffer: Record "Sales Order Entity Buffer"; SalesOrder: Record "Sales Header"; var ExtraValue1: Text; var ExtraValue2: Text; var ExtraValue3: Text; var ExtraValue4: Text; var ExtraValue5: Text; var ExtraValue6: Text; var ExtraValue7: Text; var ExtraValue8: Text; var ExtraValue9: Text; var ExtraValue10: Text);
    begin

    end;
}

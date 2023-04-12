codeunit 50003 "NAB Err Handling"
{
    var
        gCustomer: Record Customer;
        gErrorMessageMgt: Codeunit "Error Message Management";
        gErrorContextElement: Codeunit "Error Context Element";
        gErrorMessageHandler: Codeunit "Error Message Handler";

    trigger OnRun()
    begin
        ErrorHandlingExample();
    end;

    procedure ErrorHandlingExample()
    var
        LoopCount: Integer;
    begin
        ActivateErrorMessageHandling(gCustomer);

        BlockSomeCustomers(3);

        gCustomer.FindSet();
        repeat
            ProcessCustomer(LoopCount);
        until (LoopCount = 10) or (gCustomer.Next() = 0);

        if gErrorMessageHandler.HasErrors() then
            gErrorMessageHandler.ShowErrors();
        //if ErrorMessageHandler.ShowErrors() then
        //    Error('');
    end;

    local procedure ActivateErrorMessageHandling(pCustomer: Record Customer)
    begin
        if GuiAllowed then begin
            gErrorMessageMgt.Activate(gErrorMessageHandler);
            gErrorMessageMgt.PushContext(gErrorContextElement, pCustomer.RecordId, 0, '');
        end;
    end;

    local procedure BlockSomeCustomers(pLoopCount: Integer)
    var
        Customer: Record Customer;
        LoopCount: Integer;
    begin
        if Customer.FindSet(true) then
            repeat
                LoopCount += 1;
                Customer.Validate(Blocked, Customer.Blocked::All);
                Customer.Modify(true);
            until (pLoopCount = LoopCount) or (Customer.Next() = 0);
    end;

    local procedure ProcessCustomer(var pvLoopCount: Integer)
    begin
        if CanProcessCustomer(gCustomer) then begin
            pvLoopCount += 1;
        end else begin
            if GetLastErrorText <> '' then begin
                gErrorMessageMgt.LogError(gCustomer.RecordId, GetLastErrorText, '');
                ClearLastError();
            end;
        end;
    end;

    local procedure CanProcessCustomer(pCustomer: Record Customer): Boolean
    begin
        if not CheckBlockedCustomer(pCustomer) then
            exit(false);

        exit(true);
    end;

    [TryFunction]
    local procedure CheckBlockedCustomer(pCustomer: Record Customer)
    begin
        if pCustomer.IsBlocked() then
            Error(pCustomer.Name);
    end;
}

codeunit 90000 "NAB Tester"
{
#pragma warning disable AA0217 // Don't check StrSubstNo() warnings
    // version 1.4
    Description = 'Tests for the NAB KMILBAI Modifications app';
    Subtype = Test;
    TestPermissions = Disabled;

    trigger OnRun()
    begin
        gIsInitialized := false;
    end;

    #region Tests
    // CUSTOMIZATION: Add tests in this region


    #endregion Tests

    #region Init Functions
#pragma warning disable AA0228
    local procedure Initialize()
#pragma warning restore AA0228
    begin
        gLibraryTestInitialize.OnTestInitialize(Codeunit::"NAB Tester");
        ClearLastError();
        gLibraryVariableStorage.Clear();
        gLibrarySetupStorage.Restore();
        if gIsInitialized then
            exit;

        gLibraryTestInitialize.OnBeforeTestSuiteInitialize(Codeunit::"NAB Tester");

        gLibraryRandom.Init();

        // CUSTOMIZATION: Prepare setup tables etc. that are used for all test functions

        gIsInitialized := true;
        Commit();

        // CUSTOMIZATION: Add all setup tables that are changed by tests to the SetupStorage, so they can be restored for each test function that calls Initialize.
        // This is done InMemory, so it could be run after the COMMIT above
        //gLibrarySetupStorage.Save(DATABASE::"[SETUP TABLE ID]");

        gLibraryTestInitialize.OnAfterTestSuiteInitialize(Codeunit::"NAB Tester");
    end;
    #endregion Init Functions

    #region Handler Functions
    // Signatures: https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/properties/devenv-methodtype-property-test-codeunits

    [SendNotificationHandler]
    procedure SendNotificationHandler(var pNotification: Notification): Boolean
    // Call the following in the Test function
    // gLibraryVariableStorage.Enqueue('ExpectedMessage');
    begin
        gAssert.ExpectedMessage(gLibraryVariableStorage.DequeueText(), pNotification.Message());
    end;

    [MessageHandler]
    procedure ExpectedMessageHandler(pMessage: Text[1024])
    // Call the following in the Test function
    // gLibraryVariableStorage.Enqueue('ExpectedMessage');
    begin
        gAssert.ExpectedMessage(gLibraryVariableStorage.DequeueText(), pMessage);
    end;

    [ConfirmHandler]
    procedure ExpectedConfirmHandler(pQuestion: Text[1024]; var pvReply: Boolean)
    // Call the following in the Test function
    //gLibraryVariableStorage.Enqueue('ExpectedConfirmText');
    //gLibraryVariableStorage.Enqueue(TRUE); // or FALSE, depending of the reply you want if below question is asked. Any other question will throw an error
    begin
        gAssert.ExpectedMessage(gLibraryVariableStorage.DequeueText(), pQuestion);
        pvReply := gLibraryVariableStorage.DequeueBoolean();
    end;

    #endregion Handler Functions

    #region Local Functions

#pragma warning disable AA0228 // The local method is declared but never used
    local procedure CheckNothingEnqueued()
    var
        Data: Variant;
    begin
        if gLibraryVariableStorage.Length() > 0 then begin
            gLibraryVariableStorage.Dequeue(Data);
            Error('There are enqueued data that is not handled in any Handler function.\Data: %1', Data);
        end;
    end;
#pragma warning restore AA0228

    // CUSTOMIZATION: Add local functions, used by the tests

    #endregion Local Functions

    var
        gAssert: Codeunit Assert;
        gLibraryRandom: Codeunit "Library - Random";
        gLibrarySetupStorage: Codeunit "Library - Setup Storage";
        gLibraryTestInitialize: Codeunit "Library - Test Initialize";
        gLibraryVariableStorage: Codeunit "Library - Variable Storage";
        gIsInitialized: Boolean;

#pragma warning restore AA0217
}

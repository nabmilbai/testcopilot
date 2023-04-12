codeunit 90004 "NAB Test Suite"
{
    // version 2021-02-23

    [EventSubscriber(ObjectType::Page, Page::"AL Test Tool", 'OnOpenPageEvent', '', false, false)]
    local procedure ALTestTool_OnOpenPageEvent()
    var
        TesterHardcoded: Codeunit "NAB Tester Hardcoded";
    begin
        Create(TesterHardcoded.GetTestSuiteCode());
    end;

    procedure Create(pTestSuiteName: Code[10])
    var
        ALTestSuite: Record "AL Test Suite";
        TestSuiteMgt: Codeunit "Test Suite Mgt.";
    begin
        if ALTestSuite.Get(pTestSuiteName) then begin
            exit;
        end;
        TestSuiteMgt.CreateTestSuite(pTestSuiteName);
        ALTestSuite.Get(pTestSuiteName);
        TestSuiteMgt.SelectTestMethodsByExtension(ALTestSuite, GetCurrentAppId());
    end;

    local procedure GetCurrentAppId(): Guid
    var
        CurrentApp: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(CurrentApp);
        exit(CurrentApp.Id());
    end;
}
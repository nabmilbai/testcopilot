codeunit 50001 "NAB Install Handler"
{
    // version 2021-08-19
    Access = Internal;
    Subtype = Install;

    trigger OnInstallAppPerDatabase()
    begin
        if GetDataVersion() = Version.Create(0, 0, 0, 0) then // A 'DataVersion' of 0.0.0.0 indicates a 'fresh/new' install
            HandleFreshInstallPerDatabase()
        else
            HandleReinstallPerDatabase(); // If not a fresh install, then we are Re-installing the same version of the extension
    end;

    trigger OnInstallAppPerCompany()
    begin
        if GetDataVersion() = Version.Create(0, 0, 0, 0) then // A 'DataVersion' of 0.0.0.0 indicates a 'fresh/new' install
            HandleFreshInstallPerCompany()
        else
            HandleReinstallPerCompany(); // If not a fresh install, then we are Re-installing the same version of the extension
    end;

    local procedure HandleFreshInstallPerDatabase()
    begin
        // Do work needed the first time this extension is ever installed for this tenant.
        // Some possible usages:
        // - Service callback/telemetry indicating that extension was install
        // - Initial data setup for use
        AddBasicPermissionSetToAllUserGroups();
    end;

    local procedure HandleFreshInstallPerCompany()
    begin
        // Do work needed the first time this extension is ever installed for this tenant.
        // Some possible usages:
        // - Service callback/telemetry indicating that extension was install
        // - Initial data setup for use
    end;

    local procedure HandleReinstallPerDatabase()
    begin
        // Do work needed when reinstalling the same version of this extension back on this tenant.
        // Some possible usages:
        // - Service callback/telemetry indicating that extension was reinstalled
        // - Data 'patchup' work, for example, detecting if new 'base' records have been changed while you have been working 'offline'.
        // - Setup 'welcome back' messaging for next user access.
    end;

    local procedure HandleReinstallPerCompany()
    begin
        // Do work needed when reinstalling the same version of this extension back on this tenant.
        // Some possible usages:
        // - Service callback/telemetry indicating that extension was reinstalled
        // - Data 'patchup' work, for example, detecting if new 'base' records have been changed while you have been working 'offline'.
        // - Setup 'welcome back' messaging for next user access.
    end;

    local procedure AddBasicPermissionSetToAllUserGroups()
    var
        UserGroup: Record "User Group";
        Hardcoded: Codeunit "NAB Hardcoded";
        AppId: Guid;
        myAppInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(myAppInfo); // Get info about the currently executing module
        AppId := myAppInfo.Id();
        if UserGroup.FindSet() then
            repeat
                AddUserGroupFromExtension(UserGroup.Code, Hardcoded.BasicPermissionSetCode(), AppId);
            until UserGroup.Next() = 0;
    end;

    local procedure AddUserGroupFromExtension(pUserGroupCode: Code[20]; pRoleID: Code[20]; pAppID: Guid)
    var
        UserGroupPermissionSet: Record "User Group Permission Set";
    begin
        UserGroupPermissionSet.Init();
        UserGroupPermissionSet."User Group Code" := pUserGroupCode;
        UserGroupPermissionSet."Role ID" := pRoleID;
        UserGroupPermissionSet."App ID" := pAppID;
        UserGroupPermissionSet.Scope := UserGroupPermissionSet.Scope::System;
        if not UserGroupPermissionSet.Find() then
            UserGroupPermissionSet.Insert(true);
    end;

    local procedure GetDataVersion(): Version
    var
        ModInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(ModInfo);
        exit(ModInfo.DataVersion());
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Company-Initialize", 'OnCompanyInitialize', '', false, false)]
    local procedure CompanyInitialize()
    begin
        // If some setup is required on a per company basis, put the same code in the "OnCompanyInitialize" subscriber to make sure the setup is done when new companies are created.  
    end;

}
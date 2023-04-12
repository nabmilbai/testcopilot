codeunit 90002 "NAB Tester Install Handler"
{
    // version 2021-02-23

    Subtype = Install;

    trigger OnInstallAppPerDatabase()
    begin
        SetNavAppSettings();
    end;

    trigger OnInstallAppPerCompany()
    begin
        if GetDataVersion() = Version.Create(0, 0, 0, 0) then // A 'DataVersion' of 0.0.0.0 indicates a 'fresh/new' install
            HandleFreshInstall()
        else
            HandleReinstall(); // If not a fresh install, then we are Re-installing the same version of the extension
    end;

    local procedure HandleFreshInstall()
    begin
        // Do work needed the first time this extension is ever installed for this tenant.
        // Some possible usages:
        // - Service callback/telemetry indicating that extension was install
        // - Initial data setup for use
    end;

    local procedure HandleReinstall()
    begin
        // Do work needed when reinstalling the same version of this extension back on this tenant.
        // Some possible usages:
        // - Service callback/telemetry indicating that extension was reinstalled
        // - Data 'patchup' work, for example, detecting if new 'base' records have been changed while you have been working 'offline'.
        // - Setup 'welcome back' messaging for next user access.
    end;

    local procedure GetDataVersion(): Version
    var
        ModInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(ModInfo);
        exit(ModInfo.DataVersion());
    end;

    local procedure SetNavAppSettings()
    var
        NAVAppSetting: Record "NAV App Setting";
        myAppInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(myAppInfo); // Get info about the currently executing module
        if not NAVAppSetting.Get(myAppInfo.Id()) then begin
            NAVAppSetting.Init();
            NAVAppSetting."App ID" := myAppInfo.Id();
            NAVAppSetting.Insert();
        end;
        NAVAppSetting."Allow HttpClient Requests" := true;
        NAVAppSetting.Modify();
    end;
}
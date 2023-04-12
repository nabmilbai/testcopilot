codeunit 50000 "NAB Upgrade Handler"
{
    // version 1.2
    // ########################################################
    // Sample code for version checking:
    // if GetDataVersion() <= Version.Create('1.2.1.0') then begin
    //   PerformUpgradeOfSomeData()
    // end;
    // ########################################################

    Access = Internal;
    Subtype = Upgrade;

    trigger OnCheckPreconditionsPerDatabase()
    begin
        // Code to make sure database is OK to upgrade.
    end;

    trigger OnUpgradePerDatabase()
    begin
        // Code to perform database related table upgrade tasks
    end;

    trigger OnValidateUpgradePerDatabase()
    begin
        // Code to make sure that upgrade was successful for database
    end;

    trigger OnCheckPreconditionsPerCompany()
    begin
        // Code to make sure company is OK to upgrade.
    end;

    trigger OnUpgradePerCompany()
    begin
        // Code to perform company related table upgrade tasks
    end;

    trigger OnValidateUpgradePerCompany()
    begin
        // Code to make sure that upgrade was successful for each company
    end;

#pragma warning disable AA0228 // The local method is declared but never used
    local procedure GetDataVersion(): Version
    var
        ModInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(ModInfo);
        exit(ModInfo.DataVersion());
    end;
#pragma warning restore AA0228
}
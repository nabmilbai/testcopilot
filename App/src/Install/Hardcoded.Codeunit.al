codeunit 50002 "NAB Hardcoded"
{
    // version 2021-08-19
    Access = Internal;
    procedure BasicPermissionSetCode(): Code[20]
    begin
        exit('NAB Basic');
    end;
}
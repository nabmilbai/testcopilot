permissionset 50000 "NAB Basic"
{
    Assignable = true;
    Caption = 'All users', Locked = true;

    Permissions = tabledata "NAB Car Brand" = RIMD,
        tabledata "NAB Car Model" = RIMD,
        table "NAB Car Brand" = X,
        table "NAB Car Model" = X,
        page "NAB - Attachments" = X,
        page "NAB - Pstd. Purchase Invoices" = X,
        page "NAB API Car Brand" = X,
        page "NAB API Car Model" = X,
        page "NAB Style Page" = X;
}
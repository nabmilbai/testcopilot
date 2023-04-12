page 50000 "NAB Style Page"
{
    Caption = 'Style Page';
    PageType = StandardDialog;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(StandardExample; StandardName)
                {
                    Caption = 'Standard';
                    ApplicationArea = All;


                }
                field(StandardAccentExample; StandardAccentName)
                {
                    Caption = 'StandardAccent';
                    ApplicationArea = All;
                    Style = Standard;

                }
                field(StrongExample; StrongName)
                {
                    Caption = 'Strong';
                    ApplicationArea = All;
                    Style = Strong;

                }
                field(StrongAccentExample; StrongAccentName)
                {
                    Caption = 'StrongAccent';
                    ApplicationArea = All;
                    Style = StrongAccent;

                }
                field(AttentionExample; AttentionName)
                {
                    Caption = 'Attention';
                    ApplicationArea = All;
                    Style = Attention;

                }
                field(AttentionAccentExample; AttentionAccentName)
                {
                    Caption = 'AttentionAccent';
                    ApplicationArea = All;
                    Style = AttentionAccent;

                }
                field(FavorableExample; FavorableName)
                {
                    Caption = 'Favorable';
                    ApplicationArea = All;
                    Style = Favorable;

                }
                field(UnfavorableExample; UnfavorableName)
                {
                    Caption = 'Unfavorable';
                    ApplicationArea = All;
                    Style = Unfavorable;

                }
                field(AmbiguousExample; AmbiguousName)
                {
                    Caption = 'Ambiguous';
                    ApplicationArea = All;
                    Style = Ambiguous;

                }
                field(SubordinateExample; SubordinateName)
                {
                    Caption = 'Subordinate';
                    ApplicationArea = All;
                    Style = Subordinate;

                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        StandardName := 'Standard';
        StandardAccentName := 'StandardAccent';
        StrongName := 'Strong';
        StrongAccentName := 'StrongAccent';
        AttentionName := 'Attention';
        AttentionAccentName := 'AttentionAccent';
        FavorableName := 'Favorable';
        UnfavorableName := 'Unfavorable';
        AmbiguousName := 'Ambiguous';
        SubordinateName := 'Subordinate';

        Codeunit.Run(Codeunit::"NAB Err Handling");
    end;

    var
        StandardName, StandardAccentName, StrongName, StrongAccentName, AttentionName,
        AttentionAccentName, FavorableName, UnfavorableName, AmbiguousName, SubordinateName : Text;
}
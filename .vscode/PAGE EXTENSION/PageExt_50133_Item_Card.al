pageextension 50133 "Item Card Ext" extends "Item Card"
{
    layout
    {
        addlast(Item)
        {
            field("Item IMEI Details"; Rec."Item IMEI Details")
            {
                ApplicationArea = All;

                trigger OnDrillDown()
                var
                    ItemIMEIDet: Record "Item IMEI Detail";
                begin
                    Commit();
                    ItemIMEIDet.SetRange(ItemIMEIDet."Item No.", Rec."No.");
                    PAGE.Run(PAGE::"Item IMEI Details", ItemIMEIDet);
                    CurrPage.Update();
                end;

            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
pageextension 50136 "Warehouse Setup Ext" extends "Warehouse Setup"
{
    layout
    {
        addlast(General)
        {
            field("Item IMET Validation"; Rec."Item IMEI Validation")
            {
                ApplicationArea = All;
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
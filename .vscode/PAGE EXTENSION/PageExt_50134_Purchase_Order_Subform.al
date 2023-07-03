pageextension 50134 "Purchase Order Subform Ext" extends "Purchase Order Subform"
{
    layout
    {
        addbefore(Quantity)
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
                    ItemIMEIDet.SetRange(ItemIMEIDet."PO No.", rec."Document No.");
                    PAGE.Run(PAGE::"Item IMEI Details", ItemIMEIDet);
                    CurrPage.Update();
                end;

            }
        }
    }

    actions
    {
        addfirst(processing)
        {
            action("Import Item IMEI Details")
            {
                Caption = 'Import Item IMEI Details';
                Image = CreateDocument;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ItemIMEIDet.ReadExcelSheet();
                    ItemIMEIDet.ImportExcelData(Rec."Document No.");
                end;
            }
        }
    }
    var
        ItemIMEIDet: Page "Item IMEI Details";
}
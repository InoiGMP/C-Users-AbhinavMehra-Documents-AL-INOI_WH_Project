pageextension 50135 "Whse. Receipt Subform Ext" extends "Whse. Receipt Subform"
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
                    ItemIMEIDet.SetRange(ItemIMEIDet."Item No.", Rec."Item No.");
                    ItemIMEIDet.SetRange(ItemIMEIDet."PO No.", Rec."Source No.");
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
                    ItemIMEIDet.ImportExcelData(rec."Source No.");
                end;
            }
        }
    }

    var
        ItemIMEIDet: Page "Item IMEI Details";
}
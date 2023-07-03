pageextension 50138 "Warehouse Shipment Ext" extends "Warehouse Shipment"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        modify("Create Pick")
        {
            trigger OnAfterAction()
            var
                myInt: Integer;
            begin
                WhActivityLine.Reset();
                WhActivityLine.SetRange("Activity Type", WhActivityLine."Activity Type"::Pick);
                WhActivityLine.SetRange("Whse. Document Type", WhActivityLine."Whse. Document Type"::Shipment);
                WhActivityLine.SetRange("Whse. Document No.", rec."No.");
                if WhActivityLine.FindFirst() then
                    WhsePickSubform.CreateSerialNolines(WhActivityLine."No.");
            end;
        }
    }

    var
        WhsePickSubform: Page "Whse. Pick Subform";
        WhActivityLine: Record "Warehouse Activity line";
}
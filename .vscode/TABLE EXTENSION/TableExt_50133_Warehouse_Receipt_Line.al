tableextension 50133 "Warehouse Receipt Line Ext" extends "Warehouse Receipt Line"
{
    fields
    {
        field(50130; "Item IMEI Details"; Integer)
        {
            CalcFormula = count("Item IMEI Detail" WHERE("Item No." = FIELD("Item No."), "PO No." = field("Source No.")));
            Caption = 'Item IMEI Details';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    var
        myInt: Integer;
}
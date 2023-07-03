tableextension 50132 "Purchase Line Ext" extends "Purchase Line"
{
    fields
    {
        field(50130; "Item IMEI Details"; Integer)
        {
            CalcFormula = count("Item IMEI Detail" WHERE("Item No." = FIELD("No."), "PO No." = field("Document No.")));
            Caption = 'Item IMEI Details';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    var
        myInt: Integer;
}
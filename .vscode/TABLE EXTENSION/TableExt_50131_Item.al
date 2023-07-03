tableextension 50131 "Item Ext" extends Item
{
    fields
    {
        field(50130; "Item IMEI Details"; Boolean)
        {
            CalcFormula = Exist("Item IMEI Detail" WHERE("Item No." = FIELD("No.")));
            Caption = 'Item IMEI Details';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    var
        myInt: Integer;
}
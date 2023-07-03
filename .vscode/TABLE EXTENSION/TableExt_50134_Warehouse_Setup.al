tableextension 50134 "Warehouse Setup Ext" extends "Warehouse Setup"
{
    fields
    {
        field(50130; "Item IMEI Validation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
table 50130 "Item IMEI Detail"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item."No.";

            trigger OnValidate()
            begin
                RecItem.Reset();
                RecItem.SetRange(RecItem."No.", "Item No.");
                IF not RecItem.FindFirst() then begin
                    Error('Item No does not exists!');
                end;
            end;
        }
        field(3; "Serial No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "IMEI 1"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "IMEI 2"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "EAN No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "PO No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Source Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Sales Order";
            //Editable = false;
        }
        field(9; "Source No."; Code[20])
        {
            DataClassification = ToBeClassified;
            //Editable = false;
        }
        field(10; "Source Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            //Editable = false;
        }
        field(11; "Source Document No."; code[20])
        {
            DataClassification = ToBeClassified;
            //Editable = false;
        }
        field(12; "Closed"; Boolean)
        {
            DataClassification = ToBeClassified;
            //Editable = false;
        }

    }
    keys
    {
        key(Key1; "Item No.", "Serial No")
        {
            Clustered = true;
        }
        key(Key2; "Serial No", "Item No.", "IMEI 1", "IMEI 2", "EAN No")
        {
        }
    }
    var
        RecItem: Record Item;
        Record50110: Record "Item IMEI Detail";

    trigger OnInsert()
    begin
        Record50110.Reset();
        Record50110.Ascending(true);
        Record50110.SetFilter("Entry No", '<>%1', 0);
        IF Record50110.FindLast then begin
            "Entry No" := Record50110."Entry No" + 1;
        end
        else begin
            "Entry No" := 1;
        end;
    end;

    trigger OnModify()
    begin
    end;

    trigger OnDelete()
    begin
    end;

    trigger OnRename()
    begin
    end;
}

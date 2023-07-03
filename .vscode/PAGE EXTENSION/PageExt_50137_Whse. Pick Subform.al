pageextension 50137 "Whse. Pick Subform Ext" extends "Whse. Pick Subform"
{
    layout
    {
        addafter(Description)
        {
            field("Serial No"; Rec."Serial No")
            {
                ApplicationArea = All;

            }
            field("IMEI 1"; Rec."IMEI 1")
            {
                ApplicationArea = All;
                Editable = false;

            }
            field("IMEI 2"; Rec."IMEI 2")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        addbefore(SplitWhseActivityLine)
        {
            action(CreateSerialNoLines)
            {
                Caption = 'Create Lines - Serial No';
                ApplicationArea = all;
                Image = Split;

                trigger OnAction()
                var

                begin
                    CreateSerialNolines(Rec."No.");
                end;
            }

        }
    }

    procedure CreateSerialNolines(var WHsePickNo: Code[20])

    var
        TempWhactLine: Record "Warehouse Activity Line" temporary;
        WhactivityHeader: Record "Warehouse Activity Header";
        whactivityLine: Record "Warehouse Activity Line";
        LineNo: Integer;
        NewWhactivityLine: Record "Warehouse Activity Line";
    begin
        WhactivityHeader.Reset();
        WhactivityHeader.SetRange("No.", WHsePickNo);
        If WhactivityHeader.FindFirst() then begin
            LineNo := 10000;
            whactivityLine.Reset();
            whactivityLine.SetRange("No.", WhactivityHeader."No.");
            if whactivityLine.FindSet() then
                repeat
                    for i := 1 to whactivityLine.Quantity do begin

                        TempWhactLine.Reset();
                        TempWhactLine.Init();
                        TempWhactLine := whactivityLine;
                        TempWhactLine."Line No." := LineNo;
                        TempWhactLine.Quantity := 1;
                        TempWhactLine."Qty. (Base)" := 1;
                        TempWhactLine."Qty. Outstanding" := TempWhactLine.Quantity;
                        TempWhactLine."Qty. Outstanding (Base)" := TempWhactLine."Qty. (Base)";
                        TempWhactLine."Qty. to Handle" := 0;
                        TempWhactLine."Qty. to Handle (Base)" := 0;
                        TempWhactLine."Qty. Handled" := 0;
                        TempWhactLine."Qty. Handled (Base)" := 0;
                        TempWhactLine.Insert();
                        LineNo += 10000;
                    end;
                    whactivityLine.Delete();
                until whactivityLine.Next() = 0;

            TempWhactLine.SetRange("No.", WhactivityHeader."No.");
            if TempWhactLine.FindSet() then
                repeat
                    NewWhactivityLine.TransferFields(TempWhactLine);
                    NewWhactivityLine.Insert();
                until TempWhactLine.Next() = 0;
            Commit();
            TempWhactLine.DeleteAll();
        end;
    end;

    var
        i: Integer;
}

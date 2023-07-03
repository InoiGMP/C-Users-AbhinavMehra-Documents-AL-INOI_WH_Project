tableextension 50135 "Warehouse Activity Line Ext" extends "Warehouse Activity Line"
{
    fields
    {
        field(50130; "IMEI 1"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item IMEI Detail"."IMEI 1" where("Item No." = field("Item No."));
        }
        field(50131; "IMEI 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item IMEI Detail"."IMEI 2" where("Item No." = field("Item No."));
        }
        field(50132; "Serial No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item IMEI Detail"."Serial No" where("Item No." = field("Item No."));

            trigger OnLookup()
            var
                ItemIMEIDet: Record "Item IMEI Detail";
            begin
                ItemIMEIDet.Reset();
                ItemIMEIDet.SetRange("Item No.", rec."Item No.");
                ItemIMEIDet.SetRange(Closed, false);
                If page.RunModal(Page::"Item IMEI Details", ItemIMEIDet) = Action::LookupOK then;
                BEGIN
                    ItemIMEIDet.SetRange("Serial No", ItemIMEIDet."Serial No");
                    IF ItemIMEIDet.FindFirst() then begin
                        REC.Validate("Serial No", ItemIMEIDet."Serial No");
                        rec.Validate("IMEI 1", ItemIMEIDet."IMEI 1");
                        rec.Validate("IMEI 2", ItemIMEIDet."IMEI 2");
                        rec.Validate("EAN No", ItemIMEIDet."EAN No");

                        //    ItemIMEIDet."Source Type" := ItemIMEIDet."Source Type"::"Sales Order";
                        //    ItemIMEIDet."Source No." := rec."Source No.";
                        //    ItemIMEIDet."Source Line No." := Rec."Source Line No.";
                        //    ItemIMEIDet."Source Document No." := rec."No.";
                        //    ItemIMEIDet.Closed := true;
                        //    ItemIMEIDet.Modify();
                    end;
                end;
            END;

            trigger OnValidate()
            var
                ItemIMEIDet: Record "Item IMEI Detail";
                WhActLine: Record "Warehouse Activity Line";
            begin
                ItemIMEIDet.Reset();
                ItemIMEIDet.SetRange("Item No.", rec."Item No.");
                ItemIMEIDet.SetRange("Serial No", rEC."Serial No");
                ItemIMEIDet.SetRange(Closed, false);
                IF ItemIMEIDet.FindFirst() then begin
                    //REC."Serial No":= ItemIMEIDet."Serial No");
                    rec.Validate("IMEI 1", ItemIMEIDet."IMEI 1");
                    rec.Validate("IMEI 2", ItemIMEIDet."IMEI 2");
                    rec.Validate("EAN No", ItemIMEIDet."EAN No");
                    Rec.Validate("Qty. to Handle", 1);
                    rec.Validate("Qty. to Handle (Base)", 1);

                    ItemIMEIDet."Source Type" := ItemIMEIDet."Source Type"::"Sales Order";
                    ItemIMEIDet."Source No." := rec."Source No.";
                    ItemIMEIDet."Source Line No." := Rec."Source Line No.";
                    ItemIMEIDet."Source Document No." := rec."No.";

                    if rec."Action Type" = rec."Action Type"::Take then begin
                        WhActLine.Reset();
                        WhActLine.SetRange("No.", rec."No.");
                        WhActLine.SetRange("Item No.", Rec."Item No.");
                        WhActLine.SetRange("Source No.", Rec."Source No.");
                        WhActLine.SetRange("Source Line No.", Rec."Source Line No.");
                        WhActLine.SetRange("Serial No", rec."Serial No");
                        WhActLine.SetRange("Action Type", WhActLine."Action Type"::Place);
                        if WhActLine.FindFirst() then
                            ItemIMEIDet.Closed := true
                        else
                            ItemIMEIDet.Closed := false;
                    end else begin
                        if rec."Action Type" = rec."Action Type"::Place then begin
                            WhActLine.Reset();
                            WhActLine.SetRange("No.", rec."No.");
                            WhActLine.SetRange("Item No.", Rec."Item No.");
                            WhActLine.SetRange("Source No.", Rec."Source No.");
                            WhActLine.SetRange("Source Line No.", Rec."Source Line No.");
                            WhActLine.SetRange("Serial No", rec."Serial No");
                            WhActLine.SetRange("Action Type", WhActLine."Action Type"::Take);
                            if WhActLine.FindFirst() then
                                ItemIMEIDet.Closed := true
                            else
                                ItemIMEIDet.Closed := false;
                        end;
                    end;
                    ItemIMEIDet.Modify();

                end else
                    if ItemIMEIDet."Serial No" <> '' then
                        Error('Serial no %1 not belongs to %2, Please check correct serial no or choose from list', rec."Serial No", rec."Item No.")
                    else begin
                        rec."IMEI 1" := '';
                        rec."IMEI 2" := '';
                        rec."EAN No" := '';
                        Rec.Validate("Qty. to Handle", 0);
                        rec.Validate("Qty. to Handle (Base)", 0);

                        Commit();
                        ItemIMEIDet.Reset();
                        ItemIMEIDet.SetRange("Source Type", ItemIMEIDet."Source Type"::"Sales Order");
                        ItemIMEIDet.SetRange("Source Document No.", rec."No.");
                        ItemIMEIDet.SetRange("Source No.", rec."Source No.");
                        ItemIMEIDet.SetRange("Source Line No.", rec."Source Line No.");
                        if ItemIMEIDet.FindFirst() then begin
                            if ItemIMEIDet.Closed = false then begin
                                ItemIMEIDet."Source Type" := ItemIMEIDet."Source Type"::" ";
                                ItemIMEIDet."Source No." := '';
                                ItemIMEIDet."Source Line No." := 0;
                                ItemIMEIDet."Source Document No." := '';
                                ItemIMEIDet.Closed := false;
                            end else
                                if ItemIMEIDet.Closed = true then
                                    ItemIMEIDet.Closed := false;
                            ItemIMEIDet.Modify();
                        end;
                    end;

            end;


        }
        field(50133; "EAN No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item IMEI Detail"."EAN No" where("Item No." = field("Item No."));
        }
    }

    var
        myInt: Integer;
}
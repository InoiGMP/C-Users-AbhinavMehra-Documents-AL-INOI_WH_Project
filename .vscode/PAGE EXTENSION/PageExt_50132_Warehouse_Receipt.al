pageextension 50132 "Warehouse Receipt Ext" extends "Warehouse Receipt"
{
    layout
    {

    }

    actions
    {
        modify("Post Receipt")
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                WhReceiptLine.Reset();
                WhReceiptLine.SetRange("No.", Rec."No.");
                if WhReceiptLine.FindSet() then
                    repeat
                        if not Item.Get(WhReceiptLine."Item No.") then
                            exit;
                        Item.TestField("Item Tracking Code");

                        //Item IMEI details validation check
                        WhSetup.Get();
                        If WhSetup."Item IMEI Validation" = true then begin
                            WhReceiptLine.CalcFields(WhReceiptLine."Item IMEI Details");
                            if WhReceiptLine."Item IMEI Details" <> WhReceiptLine."Qty. to Receive" then
                                Error('Item IMEI Details should be equal to %1, Currently it is %2 for Item No %3', WhReceiptLine."Qty. to Receive", WhReceiptLine."Item IMEI Details", WhReceiptLine."Item No.");
                        end;

                        if ItemTrackigCode.Get(item."Item Tracking Code") then begin
                            if ItemTrackigCode."Create Pack No Info on posting" = true then begin
                                ReservationEntry.Reset();
                                ReservationEntry.SetRange("Source Type", Database::"Purchase Line");
                                ReservationEntry.SetRange("Source ID", WhReceiptLine."Source No.");
                                ReservationEntry.SetRange("Source Ref. No.", WhReceiptLine."Source Line No.");
                                if ReservationEntry.FindSet then
                                    repeat
                                        IF NOT IsPackageInfoExist() THEN
                                            CreatePackageNoInfo();
                                    until ReservationEntry.Next() = 0;
                            end;
                        end;
                    until WhReceiptLine.Next() = 0;
            end;
        }
    }

    local procedure IsPackageInfoExist(): Boolean
    var
        myInt: Integer;
    begin
        IF PackageNoInfo.Get(ReservationEntry."Item No.", ReservationEntry."Variant Code", ReservationEntry."Package No.") then
            exit(true);
        exit(false);
    end;

    local procedure ModifyPackageInfo()
    var
        myInt: Integer;
    begin
        PackageNoInfo.Description := ReservationEntry.Description;
        //You can add custom fields in Lot Information.
        PackageNoInfo.Modify();

        IsUpdated := true;
    end;

    local procedure CreatePackageNoInfo()
    var
        myInt: Integer;
    begin
        PackageNoInfo.Init();
        PackageNoInfo."Item No." := ReservationEntry."Item No.";
        PackageNoInfo."Variant Code" := ReservationEntry."Variant Code";
        PackageNoInfo."Package No." := ReservationEntry."Package No.";
        PackageNoInfo.Description := ReservationEntry.Description;
        //You can add custom fields in Lot Information.
        PackageNoInfo.Insert();
        IsUpdated := true;
    end;

    var
        PackageNoInfo: Record "Package No. Information";
        ReservationEntry: Record "Reservation Entry";
        IsUpdated: Boolean;
        ItemTrackigCode: Record "Item Tracking Code";
        PurchaseLines: Record "Purchase Line";
        WhReceiptLine: Record "Warehouse Receipt Line";
        Item: Record Item;
        WhSetup: Record "Warehouse Setup";
}
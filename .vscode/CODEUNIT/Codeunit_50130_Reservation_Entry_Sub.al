codeunit 50130 "Reservation Entry Sub"
{
    trigger OnRun()
    begin
        OnAfterValidateLotNo(ReservEntry);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Reservation Entry", 'OnbeforeinsertEvent', '', false, false)]
    procedure OnAfterValidateLotNo(var Rec: Record "Reservation Entry")
    begin
        if ReservationEntry."Lot No." = '' then begin
            ReservationEntry.Reset();
            ReservationEntry.SetCurrentKey("Entry No.");
            ReservationEntry.SetRange("Source Type", Database::"Purchase Line");
            ReservationEntry.SetRange("Source ID", Rec."Source ID");
            ReservationEntry.SetRange("Source Ref. No.", rec."Source Ref. No.");
            ReservationEntry.SetRange("Item No.", Rec."Item No.");
            if ReservationEntry.FindFirst() then begin
                rec."Lot No." := ReservationEntry."Lot No.";
                ItemTrackingPage.Update(true);
            end;
        end;
    end;

    var
        ReservationEntry: Record "Reservation Entry";
        ReservEntry: Record "Reservation Entry";
        ItemTrackingPage: Page "Item Tracking Lines";
}
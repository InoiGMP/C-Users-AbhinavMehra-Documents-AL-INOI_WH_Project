page 50130 "Item IMEI Details"
{
    ApplicationArea = All;
    Caption = 'Item IMEI Details';
    PageType = List;
    SourceTable = "Item IMEI Detail";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                    ApplicationArea = All;
                }
                field("Serial No"; Rec."Serial No")
                {
                    ToolTip = 'Specifies the value of the Serial No field.';
                    ApplicationArea = All;
                }
                field("IMEI 1"; Rec."IMEI 1")
                {
                    ToolTip = 'Specifies the value of the IMEI 1 field.';
                    ApplicationArea = All;
                }
                field("IMEI 2"; Rec."IMEI 2")
                {
                    ToolTip = 'Specifies the value of the IMEI 2 field.';
                    ApplicationArea = All;
                }
                field("EAN No"; Rec."EAN No")
                {
                    ToolTip = 'Specifies the value of the EAN No field.';
                    ApplicationArea = All;
                }
                field("PO No."; Rec."PO No.")
                {
                    ApplicationArea = All;
                }
                field("Source Document No."; Rec."Source Document No.")
                {
                    ApplicationArea = All;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = All;
                }
                field("Source Line No."; Rec."Source Line No.")
                {
                    ApplicationArea = All;
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Import Item IMEI Details")
            {
                ApplicationArea = All;
                //Promoted = true;
                //PromotedCategory = New;
                Image = NewSalesQuote;
                ToolTip = 'Import data from excel.';

                trigger OnAction()
                var
                begin
                    ReadExcelSheet();
                    ImportExcelData('');
                end;
            }
        }
    }
    var
        BatchName: Code[10];
        FileName: Text[100];
        SheetName: Text[100];
        TempExcelBuffer: Record "Excel Buffer" temporary;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        ExcelImportSucess: Label 'Excel is successfully imported.';

    procedure ReadExcelSheet()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text[100];
    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(IStream);
        end
        else
            Error(NoFileFoundMsg);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(IStream, SheetName);
        TempExcelBuffer.ReadSheet();
    end;

    procedure ImportExcelData(PONo: Code[20])
    var
        RecItemIMEI: Record "Item IMEI Detail";
        RowNo: Integer;
        ColNo: Integer;
        EntryNo: Integer;
        MaxRowNo: Integer;
        LineNo: Integer;
    begin
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;
        EntryNo := 0;
        LineNo := 0;
        RecItemIMEI.Reset();
        if RecItemIMEI.FindLast() then EntryNo := RecItemIMEI."Entry No";
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            MaxRowNo := TempExcelBuffer."Row No.";
        end;
        for RowNo := 2 to MaxRowNo do begin
            EntryNo := EntryNo + 1;
            //LineNo := LineNo + 10000;
            RecItemIMEI.Init();
            RecItemIMEI."Entry No" := EntryNo;
            RecItemIMEI.Validate(RecItemIMEI."Item No.", GetValueAtCell(RowNo, 1));
            RecItemIMEI.Validate(RecItemIMEI."Serial No", GetValueAtCell(RowNo, 2));
            RecItemIMEI.Validate(RecItemIMEI."IMEI 1", GetValueAtCell(RowNo, 3));
            RecItemIMEI.Validate(RecItemIMEI."IMEI 2", GetValueAtCell(RowNo, 4));
            RecItemIMEI.Validate(RecItemIMEI."EAN No", GetValueAtCell(RowNo, 5));
            if PONo <> '' then
                RecItemIMEI."PO No." := PONo
            else
                RecItemIMEI.Validate(RecItemIMEI."PO No.", GetValueAtCell(RowNo, 6));
            RecItemIMEI.Insert(true);
        end;
        Message(ExcelImportSucess);
    end;

    procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;
}

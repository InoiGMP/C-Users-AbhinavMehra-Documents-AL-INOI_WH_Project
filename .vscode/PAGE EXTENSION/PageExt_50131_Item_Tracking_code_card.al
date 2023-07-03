pageextension 50131 "Item Tracking Code Card Ext" extends "Item Tracking Code Card"
{
    layout
    {
        addafter("Package Specific Tracking")
        {
            field("Create Pack No Info on posting"; Rec."Create Pack No Info on posting")
            {
                ApplicationArea = All;
                Description = 'Create Package No. Info. on posting';
                ToolTip = 'Specifies that if the Package No. Information card is missing for the document line, the card will be created during posting.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
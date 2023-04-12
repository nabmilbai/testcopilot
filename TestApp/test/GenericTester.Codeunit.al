codeunit 90005 "NAB Generic Tester"
{
#pragma warning disable AA0217 // Don't check StrSubstNo() warnings
    // version 2022-09-17

    Subtype = Test;
    TestPermissions = Disabled;

    trigger OnRun()
    begin
        gIsInitialized := false;
    end;

    #region Tests 
    [Test]
    [HandlerFunctions('SelectCustomerTemplListModalPageHandler,CountriesRegionsModalPageHandler,PostCodesModalPageHandler')]
    procedure CreateCustomerTest()
    // [SCENARIO] Open the Customer Card and create a new customer.
    //            Open Customer list and find the new Customer, open card for the new customer and verify data is correct
    var
        CustomerRec: Record Customer;
        CustNo: Code[20];
        CustomerName: Text;
        CustomerCard: TestPage "Customer Card";
        CustomerList: TestPage "Customer List";
    begin
        Initialize();

        // [GIVEN] Open the Customer Card and create a new customer
        CustomerCard.OpenNew(); // -> SelectCustomerTemplListModalPageHandler
        CustomerName := CopyStr(gLibraryRandom.RandText(MaxStrLen(CustomerRec.Name)), 1, MaxStrLen(CustomerRec.Name));
        CustomerCard.Name.SetValue(CustomerName);
        CustomerCard.Address.SetValue(gLibraryRandom.RandText(MaxStrLen(CustomerRec.Address)));
        CustomerCard."Address 2".SetValue(gLibraryRandom.RandText(MaxStrLen(CustomerRec."Address 2")));
        CustomerCard."Country/Region Code".Lookup(); // -> CountriesRegionsModalPageHandler
        CustomerCard.City.Lookup(); // -> PostCodesModalPageHandler
        CustNo := CopyStr(CustomerCard."No.".Value(), 1, 20);
        CustomerCard.Close();

        // [WHEN] Open customer list and find the new customer
        CustomerList.OpenView();
        if not CustomerList.GoToKey(CustNo) then
            gAssert.Fail(StrSubstNo('Customer with No. %1 could not be found', CustNo));
        CustomerCard.Trap();
        CustomerList.View().Invoke();

        // [THEN]
        gAssert.AreEqual(CustomerName, CustomerCard.Name.Value(), 'Customer Name is not correct.');
    end;

    [Test]
    [HandlerFunctions('SelectVendorTemplListModalPageHandler,CountriesRegionsModalPageHandler,PostCodesModalPageHandler')]
    procedure CreateVendorTest()
    // [SCENARIO] Open the Vendor Card and create a new vendor. 
    //            Open Vendor list and find the new Vendor, open card for the new vendor and verify data is correct
    var
        VendorRec: Record Vendor;
        VendNo: Code[20];
        VendorName: Text;
        VendorCard: TestPage "Vendor Card";
        VendorList: TestPage "Vendor List";
    begin
        Initialize();

        // [GIVEN] Open the Vendor Card and create a new Vendor
        VendorCard.OpenNew(); // -> SelectVendorTemplListModalPageHandler
        VendorName := CopyStr(gLibraryRandom.RandText(MaxStrLen(VendorRec.Name)), 1, MaxStrLen(VendorRec.Name));
        VendorCard.Name.SetValue(VendorName);
        VendorCard.Address.SetValue(gLibraryRandom.RandText(MaxStrLen(VendorRec.Address)));
        VendorCard."Address 2".SetValue(gLibraryRandom.RandText(MaxStrLen(VendorRec."Address 2")));
        VendorCard."Country/Region Code".Lookup(); // - > CountriesRegionsModalPageHandler
        VendorCard.City.Lookup(); // -> PostCodesModalPageHandler
        VendNo := CopyStr(VendorCard."No.".Value(), 1, 20);
        VendorCard.Close();

        // [WHEN] Open Vendor list and find the new Vendor
        VendorList.OpenView();
        if not VendorList.GoToKey(VendNo) then
            gAssert.Fail(StrSubstNo('Vendor with No. %1 could not be found', VendNo));
        VendorCard.Trap();
        VendorList.View().Invoke();

        // [THEN]
        gAssert.AreEqual(VendorName, VendorCard.Name.Value(), 'Vendor Name is not correct.');
    end;

    [Test]
    [HandlerFunctions('SelectItemTemplListModalPageHandler')]
    procedure CreateItemTest()
    // [SCENARIO] Open the Item Card and create a new Item. 
    //            Open Item list and find the new Item, open card for the new Item and verify data is correct
    var
        ItemRec: Record Item;
        ItemNo: Code[20];
        ItemDescription: Text;
        ItemCard: TestPage "Item Card";
        ItemList: TestPage "Item List";
    begin
        Initialize();

        // [GIVEN] Open the Item Card and create a new Item
        ItemCard.OpenNew(); // -> SelectItemTemplListModalPageHandler
        ItemDescription := CopyStr(gLibraryRandom.RandText(MaxStrLen(ItemRec.Description)), 1, MaxStrLen(ItemRec.Description));
        ItemCard.Description.SetValue(ItemDescription);
        ItemNo := CopyStr(ItemCard."No.".Value(), 1, 20);
        ItemCard.Close();

        // [WHEN] Open Item list and find the new Item
        ItemList.OpenView();
        if not ItemList.GoToKey(ItemNo) then
            gAssert.Fail(StrSubstNo('Item with No. %1 could not be found', ItemNo));
        ItemCard.Trap();
        ItemList.View().Invoke();

        // [THEN]
        gAssert.AreEqual(ItemDescription, ItemCard.Description.Value(), 'Item Description is not correct.');
    end;


    [Test]
    [HandlerFunctions('CustomerLookupModalPageHandler')]
    procedure CreateJobTest()
    // [SCENARIO] Open the Job Card and create a new Job. 
    //            Open Job list and find the new Job, open card for the new Job and verify data is correct
    var
        JobRec: Record Job;
        JobNo: Code[20];
        JobDescription: Text;
        JobCard: TestPage "Job Card";
        JobList: TestPage "Job List";
    begin
        Initialize();

        // [GIVEN] Open the Job Card and create a new Job
        JobCard.OpenNew();
        JobDescription := CopyStr(gLibraryRandom.RandText(MaxStrLen(JobRec.Description)), 1, MaxStrLen(JobRec.Description));
        JobCard.Description.SetValue(JobDescription);
        gLibraryVariableStorage.Enqueue('CreateJob');
        JobCard."Sell-to Customer No.".Lookup(); // -> CustomerLookupModalPageHandler
        JobNo := CopyStr(JobCard."No.".Value(), 1, 20);
        JobCard.Close();

        // [WHEN] Open Job list and find the new Job
        JobList.OpenView();
        if not JobList.GoToKey(JobNo) then
            gAssert.Fail(StrSubstNo('Job with No. %1 could not be found', JobNo));
        JobCard.Trap();
        JobList.View().Invoke();

        // [THEN]
        gAssert.AreEqual(JobDescription, JobCard.Description.Value(), 'Job Description is not correct.');
        CheckNothingEnqueued();
    end;

    [Test]
    [HandlerFunctions('CustomerLookupModalPageHandler,ExpectedConfirmHandler')]
    procedure CreateAndPostSalesInvoiceTest()
    // [SCENARIO] Open the Sales Invoice Page and create a Sales Invoice with 2 Item Lines. 
    //            Post the Invoice and verify no. of Item Lines
    var
        SalesInvoiceLineRec: Record "Sales Invoice Line";
        SalesLine: Record "Sales Line";
        tItem: Record Item temporary;
        ItemNo: Code[20];
        NoOfItemLines: Integer;
        BillToName: Text[100];
        PostedSalesInvoice: TestPage "Posted Sales Invoice";
        SalesInvoice: TestPage "Sales Invoice";
    begin
        Initialize();

        // [GIVEN] Create a Sales Invoice
        SalesInvoice.OpenNew();
        gLibraryVariableStorage.Enqueue('CreateAndPostSalesInvoice');
        SalesInvoice."Sell-to Customer No.".Lookup(); // -> CustomerLookupModalPageHandler
        BillToName := CopyStr(SalesInvoice."Bill-to Name".Value(), 1, MaxStrLen(BillToName));
        SalesInvoice."Location Code".SetValue('');

        // [GIVEN] Create 2 Item Lines
        // #1
        SalesInvoice.SalesLines.FilteredTypeField.SetValue(SalesLine.Type::Item);
        ItemNo := GetItemNo(tItem);
        if ItemNo <> '' then
            SalesInvoice.SalesLines."No.".SetValue(ItemNo)
        else
            gAssert.Fail('No valid Items found for Sales Invoice');
        SalesInvoice.SalesLines.Quantity.SetValue(1);
        // #2
        SalesInvoice.SalesLines.New();
        ItemNo := GetItemNo(tItem);
        if ItemNo <> '' then
            SalesInvoice.SalesLines."No.".SetValue(ItemNo)
        else
            gAssert.Fail('No valid Items found for Sales Invoice');
        SalesInvoice.SalesLines.Quantity.SetValue(2);

        // [WHEN] Post the Invoice
        gLibraryVariableStorage.Enqueue('Do you want to post the '); // cut due to different casing in some localizations
        gLibraryVariableStorage.Enqueue(true);
        gLibraryVariableStorage.Enqueue('The invoice is posted as number');
        gLibraryVariableStorage.Enqueue(true);
        PostedSalesInvoice.Trap();
        SalesInvoice.Post.Invoke();

        // [THEN] Verify correct Bill to Customer Name and number of Item Lines
        gAssert.AreEqual(BillToName, PostedSalesInvoice."Bill-to Name".Value(), 'Name do not match on Posted Invoice.');
        gAssert.IsTrue(PostedSalesInvoice.SalesInvLines.First(), 'No lines where found on Posted Invoice');
        repeat
            if PostedSalesInvoice.SalesInvLines.FilteredTypeField.Value() = Format(SalesInvoiceLineRec.Type::Item) then
                NoOfItemLines += 1;
        until not PostedSalesInvoice.SalesInvLines.Next();
        gAssert.AreEqual(2, NoOfItemLines, 'Number of Item lines do not match between Invoice and Posted Invoice');
        CheckNothingEnqueued();
    end;

    [Test]
    [HandlerFunctions('CustomerLookupModalPageHandler,ExpectedConfirmHandler,StrMenuHandler')]
    procedure CreateAndPostSalesOrderTest()
    // [SCENARIO] Open the Sales Order Page and create a Sales Order with 2 Item Lines. 
    //            Post the Order (Ship and Invoice) and verify no. of Item Lines
    var
        SalesInvoiceLineRec: Record "Sales Invoice Line";
        SalesLine: Record "Sales Line";
        tItem: Record Item temporary;
        ItemNo: Code[20];
        NoOfItemLines: Integer;
        BillToName: Text[100];
        PostedSalesInvoice: TestPage "Posted Sales Invoice";
        SalesOrder: TestPage "Sales Order";
    begin
        Initialize();

        // [GIVEN] Create a Sales Order
        SalesOrder.OpenNew();
        gLibraryVariableStorage.Enqueue('CreateAndPostSalesOrder');
        SalesOrder."Sell-to Customer No.".Lookup(); // -> CustomerLookupModalPageHandler
        BillToName := CopyStr(SalesOrder."Bill-to Name".Value(), 1, MaxStrLen(BillToName));

        // [GIVEN] Create 2 Item Lines
        // #1
        SalesOrder.SalesLines.FilteredTypeField.SetValue(SalesLine.Type::Item);
        ItemNo := GetItemNo(tItem, GetLocationCode()); // Get Item with valid Inventory posting setup
        if ItemNo <> '' then
            SalesOrder.SalesLines."No.".SetValue(ItemNo)
        else
            gAssert.Fail('No valid Items found for Sales Invoice');
        SalesOrder.SalesLines."Location Code".SetValue(GetLocationCode()); // Set Location Code without Require Pick
        SalesOrder.SalesLines.Quantity.SetValue(1);
        // #2
        SalesOrder.SalesLines.New();
        ItemNo := GetItemNo(tItem, GetLocationCode()); // Get Item with valid Inventory posting setup
        if ItemNo <> '' then
            SalesOrder.SalesLines."No.".SetValue(ItemNo)
        else
            gAssert.Fail('No valid Items found for Sales Invoice');
        SalesOrder.SalesLines."Location Code".SetValue(GetLocationCode()); // Set Location Code without Require Pick
        SalesOrder.SalesLines.Quantity.SetValue(2);

        // [WHEN] Post the Order (Ship and Invoice)
        gLibraryVariableStorage.Enqueue('ShipAndInvoice'); // -> StrMenuHandler
        gLibraryVariableStorage.Enqueue('The order is posted as number');
        gLibraryVariableStorage.Enqueue(true);
        PostedSalesInvoice.Trap();
        SalesOrder.Post.Invoke();

        // [THEN] Verify correct Bill to Customer Name and number of Item Lines
        gAssert.AreEqual(BillToName, PostedSalesInvoice."Bill-to Name".Value(), 'Name do not match on Posted Invoice.');
        gAssert.IsTrue(PostedSalesInvoice.SalesInvLines.First(), 'No lines where found on Posted Invoice');
        repeat
            if PostedSalesInvoice.SalesInvLines.FilteredTypeField.Value() = Format(SalesInvoiceLineRec.Type::Item) then
                NoOfItemLines += 1;
        until not PostedSalesInvoice.SalesInvLines.Next();
        gAssert.AreEqual(2, NoOfItemLines, 'Number of Item lines do not match between Invoice and Posted Invoice');
        CheckNothingEnqueued();
    end;

    [Test]
    [HandlerFunctions('VendorLookupModalPageHandler,ExpectedConfirmHandler')]
    procedure CreateAndPostPurchaseInvoiceTest()
    // [SCENARIO] Open the Purchase Invoice Page and create a Purchase Invoice with 2 Item Lines. 
    //            Post the Purchase and verify no of Item Lines
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        PurchInvLineRec: Record "Purch. Inv. Line";
        tItem: Record Item temporary;
        FldRef: FieldRef;
        RecRef: RecordRef;
        ModifyHeader: Boolean;
        ItemNo: Code[20];
        VendInvNo: Code[35];
        NoOfItemLines: Integer;
        PayToName: Text[100];
        PostedPurchaseInvoice: TestPage "Posted Purchase Invoice";
        PurchaseInvoice: TestPage "Purchase Invoice";
    begin
        Initialize();

        // [GIVEN] Purchase & Payables Setup exists
        PurchasesPayablesSetup.Get();

        // [GIVEN] Create a Purchase Invoice
        PurchaseInvoice.OpenNew();
        PurchaseInvoice."Buy-from Vendor No.".Lookup(); // -> VendorLookupModalPageHandler
        PayToName := CopyStr(PurchaseInvoice."Pay-to Name".Value(), 1, MaxStrLen(PayToName));
        if PurchasesPayablesSetup."Ext. Doc. No. Mandatory" then begin
            VendInvNo := CopyStr(gLibraryRandom.RandText(MaxStrLen(VendInvNo)), 1, MaxStrLen(VendInvNo));
            PurchaseInvoice."Vendor Invoice No.".SetValue(VendInvNo);
        end;
        PurchaseInvoice."Location Code".SetValue('');

        // [GIVEN] Create 2 Item Lines
        // #1
        PurchaseInvoice.PurchLines.FilteredTypeField.SetValue(PurchaseLine.Type::Item);
        ItemNo := GetItemNo(tItem);
        if ItemNo <> '' then
            PurchaseInvoice.PurchLines."No.".SetValue(ItemNo)
        else
            gAssert.Fail('No valid Items found for Purch Invoice');
        PurchaseInvoice.PurchLines.Quantity.SetValue(1);
        //#2
        PurchaseInvoice.PurchLines.New();
        ItemNo := GetItemNo(tItem);
        if ItemNo <> '' then
            PurchaseInvoice.PurchLines."No.".SetValue(ItemNo)
        else
            gAssert.Fail('No valid Items found for Purch Invoice');
        PurchaseInvoice.PurchLines.Quantity.SetValue(2);

        // [GIVEN] Different Localization requirements are handled
        PurchaseHeader.Get(PurchaseHeader."Document Type"::Invoice, PurchaseInvoice."No.".Value());
        RecRef.GetTable(PurchaseHeader);
        if RecRef.FieldExist(32000001) then begin // FI "Invoice Message"
            FldRef := RecRef.Field(32000001);
            FldRef.Value := gLibraryRandom.RandText(20);
            ModifyHeader := true;
        end;
        if RecRef.FieldExist(12103) then begin // IT "Check Total"
            FldRef := RecRef.Field(12103);
            FldRef.Value := PurchaseInvoice.PurchLines."Total Amount Incl. VAT".Value();
            ModifyHeader := true;
        end;
        if RecRef.FieldExist(11301) then begin // NL "Doc. Amount Incl. VAT"
            FldRef := RecRef.Field(11301);
            FldRef.Value := PurchaseInvoice.PurchLines."Total Amount Incl. VAT".Value();
            ModifyHeader := true;
        end;
        if RecRef.FieldExist(11302) then begin // NL "Doc. Amount VAT"
            FldRef := RecRef.Field(11302);
            FldRef.Value := PurchaseInvoice.PurchLines."Total VAT Amount".Value(); // "Amount Including VAT" - Amount
            ModifyHeader := true;
        end;
        if ModifyHeader then
            RecRef.Modify();

        // [WHEN] Post the Invoice
        gLibraryVariableStorage.Enqueue('Do you want to post the ');
        gLibraryVariableStorage.Enqueue(true);
        gLibraryVariableStorage.Enqueue('The invoice is posted as number');
        gLibraryVariableStorage.Enqueue(true);
        PostedPurchaseInvoice.Trap();
        PurchaseInvoice.Post.Invoke();

        // [THEN] Verify correct Pay to Vendor Name and number of Item Lines
        gAssert.AreEqual(PayToName, PostedPurchaseInvoice."Pay-to Name".Value(), 'Name do not match on Posted Invoice.');
        gAssert.IsTrue(PostedPurchaseInvoice.PurchInvLines.First(), 'No lines where found on Posted Invoice');
        if PurchasesPayablesSetup."Ext. Doc. No. Mandatory" then
            gAssert.AreEqual(VendInvNo, PostedPurchaseInvoice."Vendor Invoice No.".Value(), 'Vendor Invoice No. on Posted Purchase Invoice is not correct.');
        repeat
            if PostedPurchaseInvoice.PurchInvLines.FilteredTypeField.Value() = Format(PurchInvLineRec.Type::Item) then
                NoOfItemLines += 1;
        until not PostedPurchaseInvoice.PurchInvLines.Next();
        gAssert.AreEqual(2, NoOfItemLines, 'Number of Item lines do not match between Invoice and Posted Invoice');
        CheckNothingEnqueued();
    end;
    #endregion Tests

    #region Init Functions
    local procedure Initialize()
    var
        AllObj: Record AllObj;
        RecRef: RecordRef;
    begin
        gLibraryTestInitialize.OnTestInitialize(Codeunit::"NAB Generic Tester");
        ClearLastError();
        gLibraryVariableStorage.Clear();
        gLibrarySetupStorage.Restore();
        if gIsInitialized then
            exit;

        gLibraryTestInitialize.OnBeforeTestSuiteInitialize(Codeunit::"NAB Generic Tester");

        gLibraryRandom.Init();

        // CUSTOMIZATION: Prepare setup tables etc. that are used for all test functions

        // SweBase settings
        // Deactivate SweBase modules that are not supported by the generic tests
        AllObj.SetRange("Object Type", AllObj."Object Type"::Table);
        AllObj.SetRange("Object ID", 12047977);
        if not AllObj.IsEmpty() then begin
            RecRef.Open(12047977);
            // PEB0078 Message with Doc.No when Posting Vendor Invoice
            // Purchase test don't handle raised message
            RecRef.Field(1).SetRange('PEB0078');
            if RecRef.IsEmpty() then begin
                RecRef.Field(1).Validate('PEB0078');
                RecRef.Insert(true);
            end;
            // PEB0034 - Set Allow Posting From and Allow Posting To / Styrning att endast kunna bokföra på dagens datum
            // Field "Allow posting from" & "Allow posting to" must have a value in General Ledger Setup
            RecRef.Field(1).SetRange('PEB0034');
            if RecRef.IsEmpty() then begin
                RecRef.Field(1).Validate('PEB0034');
                RecRef.Insert(true);
            end;
        end;

        gIsInitialized := true;
        Commit();

        // CUSTOMIZATION: Add all setup tables that are changed by tests to the SetupStorage, so they can be restored for each test function that calls Initialize.
        // This is done InMemory, so it could be run after the COMMIT above
        //gLibrarySetupStorage.Save(DATABASE::"[SETUP TABLE ID]");

        gLibraryTestInitialize.OnAfterTestSuiteInitialize(Codeunit::"NAB Generic Tester");
    end;
    #endregion Init Functions

    #region Handler Functions
    [ConfirmHandler]
    procedure ExpectedConfirmHandler(pQuestion: Text[1024]; var pvReply: Boolean)
    begin
        gAssert.ExpectedMessage(gLibraryVariableStorage.DequeueText(), pQuestion);
        pvReply := gLibraryVariableStorage.DequeueBoolean();
    end;

    [ModalPageHandler]
    procedure SelectCustomerTemplListModalPageHandler(var pvSelectCustomerTemplList: TestPage "Select Customer Templ. List")
    begin
        if pvSelectCustomerTemplList.First() then
            pvSelectCustomerTemplList.OK().Invoke()
        else
            pvSelectCustomerTemplList.Cancel().Invoke();
    end;

    [ModalPageHandler]
    procedure SelectVendorTemplListModalPageHandler(var pvSelectVendorTemplList: TestPage "Select Vendor Templ. List")
    begin
        if pvSelectVendorTemplList.First() then
            pvSelectVendorTemplList.OK().Invoke()
        else
            pvSelectVendorTemplList.Cancel().Invoke();
    end;

    [ModalPageHandler]
    procedure SelectItemTemplListModalPageHandler(var pvSelectItemTemplList: TestPage "Select Item Templ. List")
    begin
        if pvSelectItemTemplList.First() then
            pvSelectItemTemplList.OK().Invoke()
        else
            pvSelectItemTemplList.Cancel().Invoke();
    end;

    [ModalPageHandler]
    procedure CountriesRegionsModalPageHandler(var pvCountriesRegions: TestPage "Countries/Regions")
    begin
        if pvCountriesRegions.GoToKey('SE') then
            pvCountriesRegions.OK().Invoke()
        else
            if pvCountriesRegions.First() then
                pvCountriesRegions.OK().Invoke()
            else
                pvCountriesRegions.Cancel().Invoke();
    end;

    [ModalPageHandler]
    procedure PostCodesModalPageHandler(var pvPostCodes: TestPage "Post Codes")
    begin
        if pvPostCodes.First() then
            pvPostCodes.OK().Invoke()
        else
            pvPostCodes.Cancel().Invoke();
    end;

    [ModalPageHandler]
    procedure CustomerLookupModalPageHandler(var pvCustomerLookup: TestPage "Customer Lookup")
    var
        Customer: Record Customer;
        CustOK: Boolean;
        Mode: Text;
    begin
        Mode := gLibraryVariableStorage.DequeueText();
        CustOk := false;
        if pvCustomerLookup.First() then
            repeat
                CustOk := true;
                Customer.Get(pvCustomerLookup."No.".Value());
                if Mode = 'CreateJob' then
                    if Customer."Bill-to Customer No." <> '' then
                        CustOK := false;
                if Customer.Blocked <> Customer.Blocked::" " then
                    CustOK := false;
            until not pvCustomerLookup.Next() or CustOK;

        if CustOK then
            pvCustomerLookup.OK().Invoke()
        else
            gAssert.Fail('No valid Customer exists');
    end;

    [ModalPageHandler]
    procedure VendorLookupModalPageHandler(var pvVendorLookup: TestPage "Vendor Lookup")
    var
        Vendor: Record Vendor;
        VendOK: Boolean;
    begin
        VendOk := false;
        if pvVendorLookup.First() then
            repeat
                VendOk := true;
                Vendor.Get(pvVendorLookup."No.".Value());
                if Vendor.Blocked <> Vendor.Blocked::" " then
                    VendOK := false;
            until not pvVendorLookup.Next() or VendOK;

        if VendOK then
            pvVendorLookup.OK().Invoke()
        else
            gAssert.Fail('No valid Vendor exists');
    end;

    [StrMenuHandler]
    procedure StrMenuHandler(Option: Text[1024]; var Choice: Integer; Instruction: Text[1024])
    begin
        case gLibraryVariableStorage.DequeueText() of
            'ShipAndInvoice':
                begin
                    Choice := 3;
                end;
            else
                gAssert.Fail('Not a valid StrMenu function');
        end;
    end;
    #endregion Handler Functions

    #region Local Functions
    local procedure CheckNothingEnqueued()
    var
        Data: Variant;
    begin
        if gLibraryVariableStorage.Length() > 0 then begin
            gLibraryVariableStorage.Dequeue(Data);
            Error('There are enqueued data that is not handled in any Handler function.\Data: %1', Data);
        end;
    end;

    local procedure GetItemNo(var pvtItem: Record Item temporary): Code[20]
    var
        Item: Record Item;
    begin
        if not pvtItem.IsTemporary() then
            Error('Parameter pvtItem must be called with a temporary variable, this is a programming error');

        Item.SetRange(Blocked, false);
        Item.SetRange("Sales Blocked", false);
        Item.SetFilter("Unit Price", '<>0');
        if Item.FindSet() then
            repeat
                if not pvtItem.Get(Item."No.") then begin
                    pvtItem := Item;
                    pvtItem.Insert();
                    exit(Item."No.");
                end;
            until Item.Next() = 0;
        exit('')
    end;

    local procedure GetItemNo(var pvtItem: Record Item temporary; pLocationCode: Code[20]): Code[20]
    var
        Item: Record Item;
    begin
        if not pvtItem.IsTemporary() then
            Error('Parameter pvtItem must be called with a temporary variable, this is a programming error');
        Item.SetRange(Blocked, false);
        Item.SetRange("Sales Blocked", false);
        Item.SetFilter("Unit Price", '<>0');
        Item.SetFilter("Inventory Posting Group", GetValidInventoryPostingGroupCode(pLocationCode));
        if Item.FindSet() then
            repeat
                if not pvtItem.Get(Item."No.") then begin
                    pvtItem := Item;
                    pvtItem.Insert();
                    exit(Item."No.");
                end;
            until Item.Next() = 0;
        exit('')
    end;

    local procedure GetLocationCode(): Code[20]
    var
        Location: Record Location;
    begin
        Location.SetRange("Require Pick", false);
        Location.SetRange("Use As In-Transit", false);
        if Location.FindFirst() then
            exit(Location.Code)
        else
            gAssert.Fail('No Location with Require Pick = False found.');
    end;

    procedure GetLocalizationCode(): Code[10]
    var
        AppSysConstants: Codeunit "Application System Constants";
    begin
        exit(CopyStr(AppSysConstants.OriginalApplicationVersion(), 1, 2))
    end;

    local procedure GetValidInventoryPostingGroupCode(pLocationCode: Code[20]): Code[20]
    var
        InventoryPostingSetup: Record "Inventory Posting Setup";
    begin
        InventoryPostingSetup.SetRange("Location Code", pLocationCode);
        if InventoryPostingSetup.FindFirst() then
            exit(InventoryPostingSetup."Invt. Posting Group Code")
    end;
    #endregion Local Functions

    var
        gAssert: Codeunit Assert;
        gLibraryRandom: Codeunit "Library - Random";
        gLibrarySetupStorage: Codeunit "Library - Setup Storage";
        gLibraryTestInitialize: Codeunit "Library - Test Initialize";
        gLibraryVariableStorage: Codeunit "Library - Variable Storage";
        gIsInitialized: Boolean;
#pragma warning restore AA0217
}


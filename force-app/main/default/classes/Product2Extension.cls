public class Product2Extension {
  public List<ProductWrapper> productsToInsert { get; set; }

  public Product2Extension(ApexPages.StandardController stdController) {
    productsToInsert = new List<ProductWrapper>();
    addRows();
  }

  public void AddRows() {
    for (Integer i = 0; i < Constants.DEFAULT_ROWS; i++) {
      productsToInsert.add(new ProductWrapper());
    }
  }

  public List<ChartHelper.ChartData> GetInventory() {
    return ChartHelper.GetInventory();
  }

  public PageReference Save() {
    try {
      //insert productsToInsert;
      Savepoint sp = Database.setSavepoint();

      try {
        List<Product2> products = new List<Product2>();
        List<PricebookEntry> entries = new List<PricebookEntry>();

        for (ProductWrapper wrapper : productsToInsert) {
          Product2 product = wrapper.productRecord;
          PricebookEntry entry = wrapper.pricebookEntryRecord;

          if (
            product.Name != null &&
            product.Family != null &&
            product.Family != Constants.SELECT_ONE &&
            product.Initial_Inventory__c != null &&
            entry.UnitPrice != null
          ) {
            products.add(product);

            entry.IsActive = true;
            entry.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            entries.add(entry);
          }
        }

        if (!products.isEmpty()) {
          insert products;

          for (Integer i = 0; i < products.size(); i++) {
            entries[i].Product2Id = products[i].Id;
          }

          insert entries;

          //If successful clear the list and display an informational message
          apexPages.addMessage(
            new ApexPages.message(
              ApexPages.Severity.INFO,
              productsToInsert.size() + ' Inserted'
            )
          );
          productsToInsert.clear(); //Do not remove
          addRows(); //Do not remove
        }
      } catch (Exception ex) {
        Database.rollback(sp);
        apexPages.addMessage(
          new ApexPages.message(
            ApexPages.Severity.ERROR,
            Constants.ERROR_MESSAGE
          )
        );
      }
    } catch (Exception e) {
    }
    return null;
  }

  public List<SelectOption> getFamilyOptions() {
    List<SelectOption> values = new List<SelectOption>{
      new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE)
    };

    for (Schema.PicklistEntry entry : Constants.PRODUCT_FAMILY) {
      values.add(new SelectOption(entry.getLabel(), entry.getValue()));
    }

    return values;
  }

  public class ProductWrapper {
    public Product2 productRecord { get; set; }
    public PriceBookEntry pricebookEntryRecord { get; set; }

    public ProductWrapper() {
      this.productRecord = new Product2();
      this.pricebookEntryRecord = new PricebookEntry();
    }
  }
}

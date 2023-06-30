/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
 **/
public with sharing class TestDataFactory {
  /**
   * @name ConstructCollaborationGroup
   * @description
   **/
  public static CollaborationGroup ConstructCollaborationGroup() {
    //ToDo: Ensure this method returns a single Chatter CollaborationGroup
    //    whose Name starts with 'TEST' followed by the INVENTORY_ANNOUNCEMENTS constant
    //    and configured so anyone can join, see and post updates.
    CollaborationGroup ChatterGroup = new CollaborationGroup(
      Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS,
      CollaborationType = 'Public',
      IsArchived = false,
      IsAutoArchiveDisabled = true
    );

    return ChatterGroup;
  }

  /**
   * @name CreateProducts
   * @description Constructs a list of Product2 records for unit tests
   **/
  public static List<Product2> ConstructProducts(Integer cnt) {
    //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Product2 records
    //  with all the required fields populated
    //  and IsActive = true
    //  an Initial Inventory set to 10
    //  and iterating through the product family picklist values throughout the list.
    List<Product2> products = new List<Product2>();
    List<Schema.PicklistEntry> entries = Constants.PRODUCT_FAMILY;
    Integer val = 0;

    for (Integer i = 0; i < cnt; i++) {
      Product2 product = new Product2();
      product.Name = 'Product-' + i;
      product.IsActive = true;
      product.Initial_Inventory__c = 10;

      if (val == 4) {
        val = 0;
      }

      product.Family = entries.get(val).getValue();
      val++;

      products.add(product);
    }

    return products;
  }

  /**
   * @name CreatePricebookEntries
   * @description Constructs a list of PricebookEntry records for unit tests
   **/
  public static List<PriceBookEntry> ConstructPricebookEntries(
    List<Product2> prods
  ) {
    //ToDo: Ensure this method returns a corresponding list of PricebookEntries records
    //  related to the provided Products
    //  with all the required fields populated
    //  and IsActive = true
    //  and belonging to the standard Pricebook
    List<PriceBookEntry> entries = new List<PriceBookEntry>();

    for (Product2 product : prods) {
      PriceBookEntry entry = new PriceBookEntry();
      entry.isActive = true;
      entry.UnitPrice = 100;
      entry.Product2Id = product.id;
      entry.PriceBook2Id = Constants.STANDARD_PRICEBOOK_ID;
      entries.add(entry);
    }
    return entries;
  }

  /**
   * @name CreateAccounts
   * @description Constructs a list of Account records for unit tests
   **/
  public static list<Account> ConstructAccounts(Integer cnt) {
    //ToDo: Ensure this method returns a list of size cnt of uniquely named Account records
    //  with all of the required fields populated.
    List<Account> accounts = new List<Account>();
    for (Integer i = 0; i < cnt; i++) {
      Account account = new Account();
      account.Name = 'Account' + i;
      accounts.add(account);
    }
    return accounts;
  }

  /**
   * @name CreateContacts
   * @description Constructs a list of Contacxt records for unit tests
   **/
  public static list<Contact> ConstructContacts(
    Integer cnt,
    List<Account> accts
  ) {
    //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Contact records
    //  related to the provided Accounts
    //  with all of the required fields populated.
    list<Contact> contacts = new List<Contact>();
    for (Integer i = 0; i < cnt; i++) {
      contact contact = new contact();
      contact.LastName = 'Contact' + i;
      contact.AccountId = accts.get(i).id;
      contacts.add(contact);
    }
    return contacts;
  }

  /**
   * @name CreateOrders
   * @description Constructs a list of Order records for unit tests
   **/
  public static list<Order> ConstructOrders(Integer cnt, List<Account> accts) {
    //ToDo: Ensure this method returns a list of size cnt of uniquely named Order records
    //  related to the provided Accounts
    //  with all of the required fields populated.
    List<Order> orders = new List<Order>();
    for (Integer i = 0; i < cnt; i++) {
      Order order = new Order();
      order.Name = 'Order' + i;
      order.AccountId = accts.get(i).Id;
      order.EffectiveDate = Date.Today();
      order.Status = Constants.DRAFT_ORDER_STATUS;
      order.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
      orders.add(order);
    }

    return orders;
  }

  /**
   * @name CreateOrderItems
   * @description Constructs a list of OrderItem records for unit tests
   **/
  public static List<OrderItem> ConstructOrderItems(
    integer cnt,
    List<pricebookentry> pbes,
    List<order> ords
  ) {
    //ToDo: Ensure this method returns a list of size cnt of OrderItem records
    //  related to the provided Pricebook Entries
    //  and related to the provided Orders
    //  with all of the required fields populated.
    //  Hint: Use the DEFAULT_ROWS constant for Quantity as it will be used in the next challenge
    List<OrderItem> orderItems = new List<OrderItem>();

    for (Integer i = 0; i < cnt; i++) {
      OrderItem orderItem = new OrderItem();
      orderItem.OrderId = ords.get(i).Id;
      orderItem.PriceBookEntryId = pbes.get(i).Id;
      orderItem.Quantity = Constants.DEFAULT_ROWS;
      orderItem.UnitPrice = 10;
      orderItems.add(orderItem);
    }

    return orderItems;
  }

  /**
   * @name SetupTestData
   * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
   **/
  public static void InsertTestData(Integer cnt) {
    //ToDo: Ensure this method calls each of the construct methods
    //  and inserts the results for use as test data.
    List<Account> accounts = ConstructAccounts(cnt);
    insert accounts;

    List<Contact> contacts = ConstructContacts(cnt, accounts);
    insert contacts;

    List<Product2> prods = ConstructProducts(cnt);
    insert prods;

    List<PriceBookEntry> entries = ConstructPricebookEntries(prods);
    insert entries;

    List<Order> orders = ConstructOrders(cnt, accounts);
    insert orders;

    List<OrderItem> ordItems = ConstructOrderItems(cnt, entries, orders);
    insert ordItems;
  }
}

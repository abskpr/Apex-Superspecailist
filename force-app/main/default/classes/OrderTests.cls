@isTest
private class OrderTests {
  @TestSetup
  static void setupTestData() {
    TestDataFactory.InsertTestData(1);
  }

  @isTest
  static void OrderUpdate_UnitTest() {
    Test.startTest();
    Product2 originalProduct = [
      SELECT Id, Quantity_Ordered__c
      FROM Product2
      LIMIT 1
    ];
    Order order = [SELECT Id FROM Order LIMIT 1];
    OrderItem item = new OrderItem(
      OrderId = order.Id,
      Product2Id = originalProduct.Id,
      Quantity = 2
    );
    insert item;

    List<Order> existingOrders = [SELECT Id, Status FROM Order];

    for (Order o : existingOrders) {
      o.Status = Constants.ACTIVATED_ORDER_STATUS;
    }

    update existingOrders;
    Test.stopTest();

    Product2 updatedProduct = [
      SELECT Id, Quantity_Ordered__c
      FROM Product2
      LIMIT 1
    ];
    TestDataFactory.verifyQuantityOrdered(originalProduct, updatedProduct, 2);
  }
}

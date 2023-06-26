/**
 * @name orderTrigger
 * @description
**/
trigger orderTrigger on Order (before update, after update) {
    try {
        if ( Trigger.New != null ){
            for ( Order o : Trigger.New ){
                for ( OrderItem oi : [
                    SELECT Id, Product2Id, Product2.Quantity_Ordered__c, Quantity
                    FROM OrderItem
                    WHERE OrderId = :o.Id
                ]){
                    Product2 p = oi.Product2;
                    p.Quantity_Ordered__c -= oi.Quantity;
                    if ( o.ActivatedDate != null){
                        update p;
                    }
                }
            }
        }
    }catch ( Exception e ){
    
    }
}
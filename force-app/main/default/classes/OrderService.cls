/**
 * Created by TMARTOS on 01/07/2025.
 */

public with sharing class OrderService {
    @AuraEnabled(Cacheable=true)
    public static Decimal getSumOrdersByAccount(Id accountId) {
        Decimal totalAmount = 0;

        List<Order> orders = OrderSelector.getActivatedOrdersByAccountId(accountId);

        for (Order ord : orders) {
            if (ord.TotalAmount != null) {
                totalAmount += ord.TotalAmount;
            }
        }
        return totalAmount;
    }
}
/**
 * Created by TMARTOS on 01/07/2025.
 */

public with sharing class OrderSelector {
    @AuraEnabled(Cacheable=true)
    public static List<Order> getActivatedOrdersByAccountId(Id accountId) {
        return [
                SELECT TotalAmount
                FROM Order
                WHERE AccountId = :accountId
                AND Status = 'Activated'
        ];
    }
}

/**
 * Created by TMARTOS on 01/07/2025.
 */

public with sharing class OrderController {
    @AuraEnabled(Cacheable=true)
    public static Decimal getTotalAmountByAccount(Id accountId) {
        return OrderService.getSumOrdersByAccount(accountId);
    }
}
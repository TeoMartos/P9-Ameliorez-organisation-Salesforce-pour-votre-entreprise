/**
 * Created by TMARTOS on 22/07/2025.
 */

public with sharing class AccountController {

    @AuraEnabled(Cacheable=true)
    public static List<Account> getAccountsWithActivatedOrders(List<Id> accountIds) {
        return AccountSelector.getAccountsWithActivatedOrders(new Set<Id>(accountIds));
    }

    public static List<Account> getAllAccounts() {
        return AccountSelector.getAllAccounts();
    }

    public static Account getAccountById(Id accountIds) {
        return AccountSelector.getAccountById(accountIds);
    }
}
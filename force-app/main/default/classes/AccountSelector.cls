/**
 * Created by TMARTOS on 22/07/2025.
 */

public with sharing class AccountSelector {

    public static List<Account> getAccountsWithActivatedOrders(Set<Id> accountIds) {
        return [
                SELECT Id, Chiffre_d_affaire__c,
                (SELECT TotalAmount FROM Orders WHERE Status = 'Activated')
                FROM Account
                WHERE Id IN :accountIds
        ];
    }

    public static List<Account> getAllAccounts() {
        return [
                SELECT Id, Name, Chiffre_d_affaire__c FROM Account
        ];
    }

    public static Account getAccountById(Id accountId) {
        return [
                SELECT Id, Name, Chiffre_d_affaire__c
                FROM Account
                WHERE Id = :accountId
                LIMIT 1
        ];
    }
}

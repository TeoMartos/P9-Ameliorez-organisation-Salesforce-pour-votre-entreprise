/**
 * Created by TMARTOS on 22/07/2025.
 */

public with sharing class AccountService {

    public static void updateChiffreAffaireFromOrders(Set<Id> accountIds) {
        List<Account> accountsToUpdate = AccountSelector.getAccountsWithActivatedOrders(accountIds);

        for (Account acc : accountsToUpdate) {
            Decimal totalCA = 0;
            for (Order ord : acc.Orders) {
                if (ord.TotalAmount != null) {
                    totalCA += ord.TotalAmount;
                }
            }
            acc.Chiffre_d_affaire__c = totalCA;
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}

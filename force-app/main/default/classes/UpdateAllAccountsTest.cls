/**
 * Created by TMARTOS on 28/07/2025.
 */

@IsTest
private class UpdateAllAccountsTest {
    @IsTest
    static void test_batch_updates_accounts_with_activated_orders() {
        // Création de 3 comptes
        Account acc1 = new Account(Name = 'ACC avec commandes activées');
        Account acc2 = new Account(Name = 'ACC sans commandes activées');
        Account acc3 = new Account(Name = 'ACC sans commande');
        insert new List<Account>{ acc1, acc2, acc3 };

        // Produit et PricebookEntry
        Product2 prod = new Product2(Name = 'Produit Test', IsActive = true);
        insert prod;

        Id stdPbId = Test.getStandardPricebookId();
        PricebookEntry pbe = new PricebookEntry(
                Product2Id   = prod.Id,
                Pricebook2Id = stdPbId,
                UnitPrice    = 100,
                IsActive     = true
        );
        insert pbe;

        List<Order> ordersToUpdateStatus = new List<Order>();

        // --- ACC1 : 2 commandes qui seront activées ---
        Order o1a = new Order(AccountId=acc1.Id, Pricebook2Id=stdPbId, EffectiveDate=Date.today(), Status='Draft');
        Order o1b = new Order(AccountId=acc1.Id, Pricebook2Id=stdPbId, EffectiveDate=Date.today(), Status='Draft');
        insert new List<Order>{ o1a, o1b };

        insert new OrderItem(OrderId=o1a.Id, PricebookEntryId=pbe.Id, Quantity=2,  UnitPrice=150); // 300
        insert new OrderItem(OrderId=o1b.Id, PricebookEntryId=pbe.Id, Quantity=10, UnitPrice=200); // 2000

        o1a.Status = 'Activated';
        o1b.Status = 'Activated';
        ordersToUpdateStatus.addAll(new List<Order>{ o1a, o1b });

        // --- ACC2 : commande en Draft (ne doit pas compter) ---
        Order o2 = new Order(AccountId=acc2.Id, Pricebook2Id=stdPbId, EffectiveDate=Date.today(), Status='Draft');
        insert o2;
        insert new OrderItem(OrderId=o2.Id, PricebookEntryId=pbe.Id, Quantity=5, UnitPrice=500); // 2500 mais Draft

        update ordersToUpdateStatus;

        // Lancer le batch
        Test.startTest();
        Database.executeBatch(new UpdateAllAccounts(), 50);
        Test.stopTest();

        // Vérifications
        Account a1 = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc1.Id];
        System.assertEquals(2300, a1.Chiffre_d_affaire__c);

        Account a2 = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc2.Id];
        System.assertEquals(null, a2.Chiffre_d_affaire__c);

        Account a3 = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc3.Id];
        System.assertEquals(null, a3.Chiffre_d_affaire__c);
    }
}

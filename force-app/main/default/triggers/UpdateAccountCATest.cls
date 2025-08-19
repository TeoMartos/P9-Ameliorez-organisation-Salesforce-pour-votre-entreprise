/**
 * Created by TMARTOS on 28/07/2025.
 */

@IsTest
private class UpdateAccountCATest {
    @IsTest
    static void test_UpdateAccountCA_bulk_120_orders() {
        // Compte + produit + PBE
        Account acc = new Account(Name = 'Compte Test Bulk');
        insert acc;

        Product2 prod = new Product2(Name = 'Produit Test', IsActive = true);
        insert prod;

        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry pbe = new PricebookEntry(
                Product2Id   = prod.Id,
                Pricebook2Id = pricebookId,
                UnitPrice    = 100,
                IsActive     = true
        );
        insert pbe;

        // 120 commandes en Draft
        Integer orderCount = 120;
        List<Order> ordersToInsert = new List<Order>();
        for (Integer i = 0; i < orderCount; i++) {
            ordersToInsert.add(new Order(
                    AccountId     = acc.Id,
                    Status        = 'Draft',
                    EffectiveDate = Date.today(),
                    Pricebook2Id  = pricebookId
            ));
        }
        insert ordersToInsert;

        // 1 OrderItem par commande (200 chacune)
        List<OrderItem> itemsToInsert = new List<OrderItem>();
        for (Order o : ordersToInsert) {
            itemsToInsert.add(new OrderItem(
                    OrderId         = o.Id,
                    Quantity        = 2,
                    UnitPrice       = 100,
                    PricebookEntryId= pbe.Id
            ));
        }
        insert itemsToInsert;

        // Activer toutes les commandes en bulk
        for (Order o : ordersToInsert) {
            o.Status = 'Activated';
        }

        Test.startTest();
        update ordersToInsert;
        Test.stopTest();

        // Vérifier le CA du compte
        Decimal expectedCA = 200 * orderCount; // 24 000
        Account updatedAcc = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(expectedCA, updatedAcc.Chiffre_d_affaire__c);
    }

    @IsTest
    static void test_UpdateAccountCA_trigger_single() {
        // Compte + produit + PBE
        Account acc = new Account(Name = 'Compte Test');
        insert acc;

        Product2 prod = new Product2(Name = 'Produit Test', IsActive = true);
        insert prod;

        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry pbe = new PricebookEntry(
                Product2Id   = prod.Id,
                Pricebook2Id = pricebookId,
                UnitPrice    = 100,
                IsActive     = true
        );
        insert pbe;

        // Une commande en Draft
        Order ord = new Order(
                AccountId     = acc.Id,
                Status        = 'Draft',
                EffectiveDate = Date.today(),
                Pricebook2Id  = pricebookId
        );
        insert ord;

        insert new OrderItem(
                OrderId         = ord.Id,
                Quantity        = 2,
                UnitPrice       = 100,
                PricebookEntryId= pbe.Id
        );

        // Activer la commande
        ord.Status = 'Activated';
        update ord;

        // Vérifier le CA = 200
        Account updatedAcc = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(200, updatedAcc.Chiffre_d_affaire__c);
    }
}
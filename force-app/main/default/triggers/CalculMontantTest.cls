/**
 * Created by TMARTOS on 28/07/2025.
 */

@IsTest
private class CalculMontantTest {

    @IsTest
    static void test_calculMontant_onInsert() {
        Account acc = new Account(Name = 'Trigger Test Account');
        insert acc;

        Product2 prod = new Product2(Name = 'Produit Test', IsActive = true);
        insert prod;

        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry pbe = new PricebookEntry(
                Product2Id = prod.Id,
                Pricebook2Id = pricebookId,
                UnitPrice = 200,
                IsActive = true
        );
        insert pbe;

        Order ord = new Order(
                AccountId = acc.Id,
                Status = 'Draft',
                EffectiveDate = Date.today(),
                Pricebook2Id = pricebookId,
                ShipmentCost__c = 50
        );
        insert ord;

        OrderItem item = new OrderItem(
                OrderId = ord.Id,
                Quantity = 1,
                UnitPrice = 200,
                PricebookEntryId = pbe.Id
        );
        insert item;

        Order inserted = [SELECT NetAmount__c, TotalAmount FROM Order WHERE Id = :ord.Id];
        System.assertEquals(150, inserted.NetAmount__c, 'NetAmount__c doit être égal à TotalAmount - ShipmentCost__c');
    }

    @IsTest
    static void test_calculMontant_onUpdate() {
        Account acc = new Account(Name = 'Trigger Update Account');
        insert acc;

        Product2 prod = new Product2(Name = 'Produit Test', IsActive = true);
        insert prod;

        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry pbe = new PricebookEntry(
                Product2Id = prod.Id,
                Pricebook2Id = pricebookId,
                UnitPrice = 100,
                IsActive = true
        );
        insert pbe;

        Order ord = new Order(
                AccountId = acc.Id,
                Status = 'Draft',
                EffectiveDate = Date.today(),
                Pricebook2Id = pricebookId,
                ShipmentCost__c = 20
        );
        insert ord;

        OrderItem item = new OrderItem(
                OrderId = ord.Id,
                Quantity = 1,
                UnitPrice = 100,
                PricebookEntryId = pbe.Id
        );
        insert item;

        // Update de la ShipmentCost pour déclencher recalcul
        ord.ShipmentCost__c = 75;
        update ord;

        Order updated = [SELECT NetAmount__c, TotalAmount FROM Order WHERE Id = :ord.Id];
        System.assertEquals(25, updated.NetAmount__c, 'NetAmount__c doit être recalculé après update');
    }

    @IsTest
    static void test_calculMontant_nullValues() {
        Account acc = new Account(Name = 'Test Null Values');
        insert acc;

        Order ord = new Order(
                AccountId = acc.Id,
                Status = 'Draft',
                EffectiveDate = Date.today(),
                Pricebook2Id = Test.getStandardPricebookId(),
                ShipmentCost__c = 30
                // Pas de OrderItem, donc TotalAmount sera null
        );
        insert ord;

        Order result = [SELECT NetAmount__c, TotalAmount FROM Order WHERE Id = :ord.Id];
        System.assertEquals(null, result.NetAmount__c, 'NetAmount__c doit être null si TotalAmount est null');
    }
}

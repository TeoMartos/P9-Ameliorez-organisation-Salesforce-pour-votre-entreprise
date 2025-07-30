/**
 * Created by TMARTOS on 28/07/2025.
 */

@IsTest
private class UpdateAccountCATest {

    @IsTest
    static void test_UpdateAccountCA_trigger() {
        // Création d’un compte
        Account acc = new Account(Name = 'Compte Test');
        insert acc;

        // Création d’un produit
        Product2 prod = new Product2(Name = 'Produit Test', IsActive = true);
        insert prod;

        // Récupération du Pricebook standard
        Id pricebookId = Test.getStandardPricebookId();

        // Ajout du produit au pricebook
        PricebookEntry pbe = new PricebookEntry(
                Product2Id = prod.Id,
                Pricebook2Id = pricebookId,
                UnitPrice = 100,
                IsActive = true
        );
        insert pbe;

        // Création d’une commande en brouillon
        Order ord = new Order(
                AccountId = acc.Id,
                Status = 'Draft',
                EffectiveDate = Date.today(),
                Pricebook2Id = pricebookId
        );
        insert ord;

        // Ajout d’un OrderItem
        OrderItem item = new OrderItem(
                OrderId = ord.Id,
                Quantity = 2,
                UnitPrice = 100,
                PricebookEntryId = pbe.Id
        );
        insert item;

        // Activation de la commande (déclenche le trigger)
        ord.Status = 'Activated';
        update ord;

        // Vérification que le chiffre d’affaires a été mis à jour
        Account updatedAcc = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(200, updatedAcc.Chiffre_d_affaire__c, 'Le chiffre d’affaire doit être mis à jour à 200');
    }
}

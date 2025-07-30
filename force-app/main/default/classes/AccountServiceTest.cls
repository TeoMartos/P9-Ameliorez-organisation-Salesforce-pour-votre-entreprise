/**
 * Created by TMARTOS on 28/07/2025.
 */

@IsTest
public class AccountServiceTest {

    @IsTest
    static void test_updateChiffreAffaireFromOrders() {
        // Setup d'un compte
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Setup d'un produit et pricebook
        Product2 prod = new Product2(Name = 'Produit test', IsActive = true);
        insert prod;

        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry pbe = new PricebookEntry(
                Product2Id = prod.Id,
                Pricebook2Id = pricebookId,
                UnitPrice = 150,
                IsActive = true
        );
        insert pbe;

        // Création d'une commande avec un item
        Order ord = new Order(
                AccountId = acc.Id,
                Status = 'Draft',
                EffectiveDate = Date.today(),
                Pricebook2Id = pricebookId
        );
        insert ord;

        OrderItem item = new OrderItem(
                OrderId = ord.Id,
                Quantity = 1,
                UnitPrice = 150,
                PricebookEntryId = pbe.Id
        );
        insert item;

        // Activation de la commande
        ord.Status = 'Activated';
        update ord;

        // Appel de la méthode de service
        Set<Id> ids = new Set<Id>{ acc.Id };
        AccountService.updateChiffreAffaireFromOrders(ids);

        // Requête pour vérification
        Account result = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];

        System.assertEquals(150, result.Chiffre_d_affaire__c, 'Le chiffre d\'affaires doit être égal au TotalAmount de la commande');
    }
}
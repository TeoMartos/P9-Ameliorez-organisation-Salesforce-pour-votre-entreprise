/**
 * Created by TMARTOS on 28/07/2025.
 */

@IsTest
public class OrderControllerTest {

    @IsTest
    static void test_getTotalAmountByAccount() {
        // Création d’un compte
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Création d’un produit actif
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true);
        insert prod;

        Id pbId = Test.getStandardPricebookId();

        // PricebookEntry actif
        PricebookEntry pbe = new PricebookEntry(
                Product2Id = prod.Id,
                Pricebook2Id = pbId,
                UnitPrice = 300,
                IsActive = true
        );
        insert pbe;

        // Création d’une commande en statut Draft
        Order ord = new Order(
                AccountId = acc.Id,
                Status = 'Draft',
                EffectiveDate = Date.today(),
                Pricebook2Id = pbId
        );
        insert ord;

        // Ajout d’un OrderItem
        OrderItem item = new OrderItem(
                OrderId = ord.Id,
                Quantity = 2,
                UnitPrice = 300,
                PricebookEntryId = pbe.Id
        );
        insert item;

        // Activation de la commande
        ord.Status = 'Activated';
        update ord;

        // Appel de la méthode à tester
        Decimal result = OrderController.getTotalAmountByAccount(acc.Id);

        // Assertions
        System.assertEquals(600, result, 'Le montant total doit être 600');
    }
}

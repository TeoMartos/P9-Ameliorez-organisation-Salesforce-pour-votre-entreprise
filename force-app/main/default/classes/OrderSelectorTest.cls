/**
 * Created by TMARTOS on 28/07/2025.
 */

@IsTest
public class OrderSelectorTest {

    @IsTest
    static void test_getActivatedOrdersByAccountId() {
        // Création d'un compte
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Création d’un produit
        Product2 prod = new Product2(Name = 'Produit Test', IsActive = true);
        insert prod;

        Id pbId = Test.getStandardPricebookId();

        // Création d’un PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
                Product2Id = prod.Id,
                Pricebook2Id = pbId,
                UnitPrice = 200,
                IsActive = true
        );
        insert pbe;

        // Création d’une commande en mode Draft
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
                Quantity = 1,
                UnitPrice = 200,
                PricebookEntryId = pbe.Id
        );
        insert item;

        // Activation de la commande
        ord.Status = 'Activated';
        update ord;

        // Appel de la méthode à tester
        List<Order> result = OrderSelector.getActivatedOrdersByAccountId(acc.Id);

        // Assertions
        System.assertEquals(1, result.size(), 'Une commande activée doit être retournée');
        System.assertEquals(200, result[0].TotalAmount, 'Le montant total doit correspondre');
    }
}

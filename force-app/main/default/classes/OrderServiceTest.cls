/**
 * Created by TMARTOS on 28/07/2025.
 */

@IsTest
public class OrderServiceTest {

    @IsTest
    static void test_getSumOrdersByAccount() {
        // Création d’un compte
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Produit actif
        Product2 prod = new Product2(Name = 'Produit Test', IsActive = true);
        insert prod;

        Id pbId = Test.getStandardPricebookId();

        // PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
                Product2Id = prod.Id,
                Pricebook2Id = pbId,
                UnitPrice = 150,
                IsActive = true
        );
        insert pbe;

        // Order statut draft
        Order ord = new Order(
                AccountId = acc.Id,
                Status = 'Draft',
                EffectiveDate = Date.today(),
                Pricebook2Id = pbId
        );
        insert ord;

        // OrderItem
        OrderItem item = new OrderItem(
                OrderId = ord.Id,
                Quantity = 2,
                UnitPrice = 150,
                PricebookEntryId = pbe.Id
        );
        insert item;

        // Passage au statut Activated
        ord.Status = 'Activated';
        update ord;

        // Appel de la méthode
        Decimal result = OrderService.getSumOrdersByAccount(acc.Id);

        // Vérification
        System.assertEquals(300, result, 'Le montant total doit être 300');
    }
}

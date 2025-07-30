/**
 * Created by TMARTOS on 22/07/2025.
 */

@IsTest
public class AccountSelectorTest {

    @IsTest
    static void test_getAccountsWithActivatedOrders() {
        // 1. Créer un compte
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // 2. Créer un produit
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true);
        insert prod;

        // 3. Récupérer le Pricebook standard
        Id pricebookId = Test.getStandardPricebookId();

        // 4. Créer une PricebookEntry (le prix du produit dans le catalogue)
        PricebookEntry pbe = new PricebookEntry(
                Product2Id = prod.Id,
                Pricebook2Id = pricebookId,
                UnitPrice = 100,
                IsActive = true
        );
        insert pbe;

        // 5. Créer un Order avec statut Draft
        Order testOrder = new Order(
                AccountId = testAccount.Id,
                Status = 'Draft',
                EffectiveDate = Date.today(),
                Pricebook2Id = pricebookId
        );
        insert testOrder;

        // 6. Ajouter un OrderItem (produit commandé)
        OrderItem item = new OrderItem(
                OrderId = testOrder.Id,
                Quantity = 1,
                UnitPrice = 100,
                PricebookEntryId = pbe.Id
        );
        insert item;

        // 7. Mise à jour du statut de la commande à Activated
        testOrder.Status = 'Activated';
        update testOrder;

        // 8. Appel de la méthode à tester
        Set<Id> accountIds = new Set<Id>{testAccount.Id};
        List<Account> result = AccountSelector.getAccountsWithActivatedOrders(accountIds);

        System.assertEquals(1, result.size(), 'Il doit y avoir un compte');
        System.assertEquals(1, result[0].Orders.size(), 'Le compte doit avoir 1 commande');
    }

    @IsTest
    static void test_getAllAccounts() {
        Account acc1 = new Account(Name = 'Test Account 1');
        Account acc2 = new Account(Name = 'Test Account 2');
        insert new List<Account>{acc1, acc2};

        List<Account> accounts = AccountSelector.getAllAccounts();

        System.assert(accounts.size() >= 2, 'Il doit y avoir au moins deux comptes retournés');
    }
}

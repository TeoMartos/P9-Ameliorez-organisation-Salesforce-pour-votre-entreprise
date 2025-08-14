/**
 * Created by TMARTOS on 28/07/2025.
 */

@IsTest
public class AccountControllerTest {

    @IsTest
    static void test_getAccountsWithActivatedOrders() {
        // Setup
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Product2 prod = new Product2(Name = 'Test Product', IsActive = true);
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
                Pricebook2Id = pricebookId
        );
        insert ord;

        OrderItem item = new OrderItem(
                OrderId = ord.Id,
                Quantity = 1,
                UnitPrice = 100,
                PricebookEntryId = pbe.Id
        );
        insert item;

        ord.Status = 'Activated';
        update ord;

        // Appel méthode
        List<Account> accounts = AccountController.getAccountsWithActivatedOrders(new List<Id>{ acc.Id });

        System.assertEquals(1, accounts.size(), 'Un compte doit être retourné');
        System.assertEquals(1, accounts[0].Orders.size(), 'Le compte doit avoir 1 commande');
    }

    @IsTest
    static void test_getAllAccounts() {
        Account acc1 = new Account(Name = 'Test A');
        Account acc2 = new Account(Name = 'Test B');
        insert new List<Account>{acc1, acc2};

        List<Account> result = AccountController.getAllAccounts();

        System.assert(result.size() >= 2, 'Doit retourner au moins 2 comptes');
    }

    @IsTest
    static void test_getAccountById() {
        Account acc = new Account(Name = 'Single Account');
        insert acc;

        Account result = AccountController.getAccountById(acc.Id);

        System.assertNotEquals(null, result, 'Le compte ne doit pas être null');
        System.assertEquals(acc.Id, result.Id, 'L\'ID du compte doit correspondre');
    }
}

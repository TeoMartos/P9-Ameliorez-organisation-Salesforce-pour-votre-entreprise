@IsTest
private class testUpdateAllAccounts {

    @IsTest static void test() {
        // 1) Données de base
        Account acc1 = new Account(Name = 'Test Account 1');
        insert acc1;

        // 2) Produit actif + PBE sur le Standard Pricebook
        Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise', IsActive = true);
        insert pd1;

        Id stdPbId = Test.getStandardPricebookId();

        PricebookEntry pbe = new PricebookEntry(
                Pricebook2Id = stdPbId,
                Product2Id   = pd1.Id,
                UnitPrice    = 1020,
                IsActive     = true
        );
        insert pbe;

        // 3) Order : IMPORTANT -> Pricebook2Id + EffectiveDate + Status (Draft d'abord)
        Order o1 = new Order(
                AccountId     = acc1.Id,
                Pricebook2Id  = stdPbId,
                EffectiveDate = Date.newInstance(2025, 8, 14),
                Status        = 'Draft'
        );
        insert o1;

        // 4) OrderItems (crée le TotalAmount)
        insert new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity = 10, UnitPrice = 150);   // 1500
        insert new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity = 20, UnitPrice = 1000);  // 20000

        // 5) Réinterroger pour récupérer le TotalAmount, puis activer (déclenche UpdateAccountCA)
        o1 = [SELECT Id, TotalAmount, Status FROM Order WHERE Id = :o1.Id];
        o1.Status = 'Activated';
        update o1;

        // 6) Vérifier que le CA a été mis à jour sur le compte
        Account accAfter = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :acc1.Id];
        System.assertNotEquals(null, accAfter.Chiffre_d_affaire__c, 'Le CA ne doit pas être null après activation');
        System.assertEquals(o1.TotalAmount, accAfter.Chiffre_d_affaire__c,
                'Le CA du compte doit égaler la somme des commandes activées');
    }
}

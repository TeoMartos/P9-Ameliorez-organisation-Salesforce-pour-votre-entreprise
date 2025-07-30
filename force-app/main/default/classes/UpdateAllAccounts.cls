global class UpdateAllAccounts implements Database.Batchable<SObject>{
    
    global Database.QueryLocator start(Database.BatchableContext info){ 
        //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Activated'
        return Database.getQueryLocator([
                SELECT Id
                FROM Account
                WHERE Id IN (
                        SELECT AccountId
                        FROM Order
                        WHERE Status = 'Activated'
                )
        ]);
 
    }
     
    global void execute(Database.BatchableContext info, List<Account> scope){
        Set<Id> setAccountIds = (new Map<Id,SObject>(scope)).keySet();
        AccountService.updateChiffreAffaireFromOrders(setAccountIds);
    }    

    global void finish(Database.BatchableContext info){
    }
 }
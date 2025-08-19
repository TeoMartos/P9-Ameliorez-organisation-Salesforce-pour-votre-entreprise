trigger UpdateAccountCA on Order (after update) {
    Set<Id> accountIdsToUpdate = new Set<Id>();

    for (Order ord : Trigger.new) {
        Order oldOrd = Trigger.oldMap.get(ord.Id);

        if (ord.Status == 'Activated' && oldOrd.Status != 'Activated' && ord.AccountId != null) {
            accountIdsToUpdate.add(ord.AccountId);
        }
    }//test

    if (!accountIdsToUpdate.isEmpty()) {
        AccountService.updateChiffreAffaireFromOrders(accountIdsToUpdate);
    }
}

trigger CalculMontant on Order (before insert, before update) {
	for (Order ord : Trigger.new) {
		if (ord.TotalAmount != null && ord.ShipmentCost__c != null && ord.TotalAmount > 0) {
			ord.NetAmount__c = ord.TotalAmount - ord.ShipmentCost__c;
		} else {
			ord.NetAmount__c = null;
		}
	}
}

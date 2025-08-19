trigger AmountCalculation on Order (before insert, before update) {
	for (Order ord : Trigger.new) {

		if (ord.TotalAmount == null || ord.TotalAmount == 0) {
			ord.NetAmount__c = null;
			continue;
		}

		Decimal shipment = (ord.ShipmentCost__c == null) ? 0 : ord.ShipmentCost__c;
		ord.NetAmount__c = ord.TotalAmount - shipment;
	}
}

import { LightningElement, api, wire } from 'lwc';
import getTotalAmountByAccount from '@salesforce/apex/OrderController.getTotalAmountByAccount';

export default class Orders extends LightningElement {
    @api recordId;
    sumOrdersOfCurrentAccount;

    get hasOrders() {
        return this.sumOrdersOfCurrentAccount && this.sumOrdersOfCurrentAccount > 0;
    }

    connectedCallback() {
        this.fetchSumOrders();
    }

    fetchSumOrders() {
        getTotalAmountByAccount({ accountId: this.recordId })
            .then(result => {
                this.sumOrdersOfCurrentAccount = result;
            })
            .catch(error => {
                console.error('Erreur LWC : ', error);
                this.sumOrdersOfCurrentAccount = null;
            });
    }
}

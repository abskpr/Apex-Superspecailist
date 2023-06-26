public class Constants {
	static final Integer DEFAULT_ROWS = 5;
    static final String SELECT_ONE = System.Label.Select_One;
    static final String INVENTORY_LEVEL_LOW = System.Label.Inventory_Level_Low;
    static final String DRAFT_ORDER_STATUS = 'Draft';
    static final String ACTIVATED_ORDER_STATUS = 'Active';
    static final String INVENTORY_ANNOUNCEMENTS = 'Inventory Announcements';
    static final String ERROR_MESSAGE = 'An error has occurred, please take a screenshot with the URL and send it to IT.';
    static final String STANDARD_PRICEBOOK_ID = '01s2w00000IN9XKAA1';
    static final List<Schema.PicklistEntry> PRODUCT_FAMILY = Product2.Family.getDescribe().getPicklistValues();
}
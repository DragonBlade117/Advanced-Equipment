class CfgWeapons {
	class CBA_MiscItem;
	class CBA_MiscItem_ItemInfo;

	class Item_FlashDisk_AE3 : CBA_MiscItem
	{
		author[] = {"Wasserstoff"};
        scope = 1;
        displayName = "$STR_AE3_Flashdrive_DisplayName";
        descriptionShort = "$STR_AE3_Flashdrive_DescrShort";
		useActionTitle = "$STR_AE3_Flashdrive_UseActionTitle";

        model = "\A3\Props_F_Oldman\Items\USB_Dongle_01_F.p3d";
        picture = "\z\ae3\addons\flashdrive\ui\AE3_flashdrive_ca.paa";

		ae3_vehicle = Land_USB_Dongle_01_F_AE3;

		class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 1;
			scope = 0;
        };
	};

	ITEM_ID_LIST(Item_FlashDisk_AE3, Flash drive )
};
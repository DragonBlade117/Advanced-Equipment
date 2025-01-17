/**
 * PRIVATE
 *
 * This function is assigned in module config and will be triggered after mission start and if the module is placed by zeus on every computer.
 * The function will only run on server and only if placed in eden editor. The module will be deleted after processing.
 * The effect of this module applies to all syncted entities.
 *
 * Arguments:
 * 1: Module <OBJECT>
 * 2: Synced Units <[OBJECT]>
 * 3: Activated <BOOL> currently unused in this function
 *
 * Results:
 * 1: Success <BOOL> true = success and false = error
 *
 */

params["_module", "_syncedUnits", "_activated"];

// ignore this function if module is placed by curator/zeus
if (_module getvariable ["BIS_fnc_moduleInit_isCuratorPlaced", false]) exitWith { false; };

if (!isServer) exitWith {};

if (_activated) then 
{
	[_module, _syncedUnits] spawn
	{
		params["_module", "_syncedUnits"];

		waitUntil { !isNil "BIS_fnc_init" };

		//--- Extract the user defined module arguments
		private _username = _module getVariable ["AE3_ModuleUserlist_User", ""];
		private _password = _module getVariable ["AE3_ModuleUserlist_Password", ""];

		// check for empty username or password
		if (_username isEqualTo "") exitWith { deleteVehicle _module; false; };
		if (_password isEqualTo "") exitWith { deleteVehicle _module; false; };

		// check for not allowed spaces in username
		if((_username find " ") != -1) exitWith { deleteVehicle _module; false; };

		{
			//--- Add user to every synced computer
			[_x, _username, _password] call AE3_armaos_fnc_computer_addUser;
		} foreach _syncedUnits;

		deleteVehicle _module;
	};
};

true;
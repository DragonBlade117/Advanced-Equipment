/**
 * Sets the power state for a given device if value is changed in Eden Editor.
 *
 * Arguments:
 * 0: Device <OBJECT>
 * 
 * Returns:
 * None
 */

params ["_device"];

[_device] spawn
{
    params ["_device"];

    // wait until the eden attribute is set via expression; unset is -1; regular values should be between 0 and 1
    waitUntil { !(isNil {_device getVariable "AE3_EdenAttribute_PowerState"}) };

    private _edenAttributePowerState = _device getVariable "AE3_EdenAttribute_PowerState";

	if (!_edenAttributePowerState) exitWith {diag_log "AE3: Not set";};

    // wait until all "init" processes are done, see: https://community.bistudio.com/wiki/Initialization_Order
    waitUntil { !isNil "BIS_fnc_init" };

	private _condition = ((_device call (_device getVariable ["AE3_power_fnc_turnOnCondition", {true}]) and
							(alive _device) and 
						(_device getVariable 'AE3_power_powerState' != 1) and 
						!(_device getVariable ['AE3_power_mutex', false]) and 
						(_device getVariable ['AE3_interaction_closeState', 0] == 0)));
	//if (_condition) exitWith {diag_log "AE3: Condition not met";};

	[_device, [true]] call (_device getVariable "AE3_power_fnc_turnOnWrapper");
	_device setVariable ['AE3_power_mutex', false, true];
};
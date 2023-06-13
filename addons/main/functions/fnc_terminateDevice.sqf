params ["_device"];

systemchat format ["Deleted entity (General): %1", _device];

/* ================================================================================ */

// turn off device
[_device] call AE3_power_fnc_turnOffDevice;

/* ================================================================================ */

// if _device == power provider (has connected power devices) then remove all power connections from connected power consumers
private _connectedPowerConsumers = _device getVariable ["AE3_power_connectedDevices", []];
{
    [_x] call AE3_power_fnc_removePowerConnection;
} forEach _connectedPowerConsumers;
// safely remove all power connections from power provider itself
_connectedPowerConsumers = [];
_device setVariable ["AE3_power_connectedDevices", _connectedPowerConsumers, true];

// if _device == power consumer (has a connected power cable device) then remove power connection
private _powerProvider = _device getVariable ["AE3_power_powerCableDevice", objNull];
if(!(isNull _powerProvider)) then
{
    [_device] call AE3_power_fnc_removePowerConnection;
};

/* ================================================================================ */

// if _device == network provider (has connected network devices) then remove all network connections from connected network consumers
private _connectedNetworkConsumers = _device getVariable ["AE3_network_children", []];
{
    [_x] call AE3_network_fnc_removeNetworkConnection;
} forEach _connectedNetworkConsumers;
// safely remove all network connections from network provider itself
_connectedNetworkConsumers = [];
_device setVariable ["AE3_network_children", _connectedNetworkConsumers, true];

// if _device == network consumer (has a network parent) then remove network connection
private _networkProvider = _device getVariable ["AE3_network_parent", objNull];
if(!(isNull _networkProvider)) then
{
    [_device] call AE3_power_fnc_removeNetworkConnection;
};

/* ================================================================================ */

/*
private _class = typeOf _device;
if (_class isEqualTo "ModuleCurator_F") then
{
    _device addEventHandler ["CuratorObjectDeleted", {
        params ["_curator", "_device"];

        systemchat format ["Deleted entity (Curator): %1", _device];
    }];

    _device addEventHandler ["CuratorObjectEdited", {
        params ["_curator", "_device"];

        systemchat format ["Edited entity (Curator): %1", _device];
    }];

    _device addEventHandler ["CuratorObjectPlaced", {
        params ["_curator", "_device"];

        systemchat format ["Placed entity (Curator): %1", _device];
    }];
};
*/
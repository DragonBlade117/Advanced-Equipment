/**
 * PRIVATE
 *
 * This function is assigned to the 'onLoad' and 'onUnload' Events of the Zeus Module Interface: addDir
 * This function runs local on the computer of the curator/zeus because it is UI triggered.
 * The function makes changes to the asset according the the user input.
 * This module needs to be placed onto a asset with an filesystem.
 * After processing the module will be deleted.
 *
 * Arguments:
 * 1: Display <OBJECT>
 * 2: Exit Code <NUMBER>
 * 3: Event <STRING>
 *
 * Results:
 * None
 *
 */

params ["_display", "_exitCode", "_event"];

private _module = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target", objNull];
if (isNull _module) exitWith {};

/* ---------------------------------------- */

if (_event isEqualTo "onLoad") exitWith
{
    private _result = [_display] call AE3_main_fnc_zeus_checkForComputer;
    _result params ["_status", "_computer"];

    if (_status isEqualTo "SUCCESS") then
    {
        // add computer variable to display namespace
        _display setVariable ["AE3_linkedComputer", _computer];
    }
    else
    {
        // close display
        _display closeDisplay 2; // 2 = cancel
    };
};

/* ---------------------------------------- */

if (_event isEqualTo "onUnload") exitWith
{
    private _computer = _display getVariable ["AE3_linkedComputer", objNull];
    if ((isNull _computer) || (_exitCode == 2)) exitWith
    {
        // delete module if dialog cancelled or computer not linked to module
        deleteVehicle _module;
    };

    // get values from UI
    private _pathCtrl = _display displayCtrl 1401;
    private _ownerCtrl = _display displayCtrl 1403;
    private _ownerReadCtrl = _display displayCtrl 1302;
    private _ownerWriteCtrl = _display displayCtrl 1303;
    private _ownerExecuteCtrl = _display displayCtrl 1304;
    private _everyoneReadCtrl = _display displayCtrl 1305;
    private _everyoneWriteCtrl = _display displayCtrl 1306;
    private _everyoneExecuteCtrl = _display displayCtrl 1307;
    private _path = ctrlText _pathCtrl;
    private _owner = ctrlText _ownerCtrl;
    private _ownerRead = cbChecked _ownerReadCtrl;
    private _ownerWrite = cbChecked _ownerWriteCtrl;
    private _ownerExecute = cbChecked _ownerExecuteCtrl;
    private _everyoneRead = cbChecked _everyoneReadCtrl;
    private _everyoneWrite = cbChecked _everyoneWriteCtrl;
    private _everyoneExecute = cbChecked _everyoneExecuteCtrl;
    private _permissions = [[_ownerExecute, _ownerRead, _ownerWrite], [_everyoneExecute, _everyoneRead, _everyoneWrite]];

    // check for empty but mandatory input fields
    // module is still there an could be opened and filled in with valid input
    // but currently, this case will be catched by UI logic, defined directly in config
    if(_path isEqualTo "") exitWith { [objNull, localize "STR_AE3_Main_Zeus_PathMissing"] call BIS_fnc_showCuratorFeedbackMessage; };
    if(_owner isEqualTo "") exitWith { [objNull, localize "STR_AE3_Main_Zeus_OwnerMissing"] call BIS_fnc_showCuratorFeedbackMessage; };

    // check for not allowed spaces in path and owner
    if((_path find " ") != -1) exitWith { [objNull, localize "STR_AE3_Main_Zeus_PathContainsSpaces"] call BIS_fnc_showCuratorFeedbackMessage; };
    if((_owner find " ") != -1) exitWith { [objNull, localize "STR_AE3_Main_Zeus_OwnerContainsSpaces"] call BIS_fnc_showCuratorFeedbackMessage; };

    // add directory to computer
    [_computer, _path, _owner, _permissions] remoteExecCall ["AE3_filesystem_fnc_device_addDir", 2];

    private _message = format ["%1: %2", localize "STR_AE3_Main_Zeus_Path", _path];
    [localize "STR_AE3_Main_Zeus_DirectoryAdded", _message, 5] call BIS_fnc_curatorHint;

    // delete module if dialog cancelled or computer not linked to module
    deleteVehicle _module;
};

/* ---------------------------------------- */
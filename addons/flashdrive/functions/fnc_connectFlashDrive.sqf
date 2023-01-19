/**
 * Physically connects a flash drive to a computer
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Flashdrive type <STRING>
 * 3: Interface state <ARRAY>
 *
 * Results:
 * None
 */

params['_computer', '_flashDrive', '_USBInterface'];

_USBInterface params ['_occupied', '_mounted', '_name', '_rel_pos', '_rot_yaw', '_rot_pitch', '_rot_roll'];

if(!(isNull _occupied)) exitWith {};

private _object = [player, _flashDrive] call AE3_flashdrive_fnc_item2obj;

if(isNull _object) exitWith {};

_object attachTo [_computer, _rel_pos];
[_object, [_rot_yaw, _rot_pitch, _rot_roll]] call BIS_fnc_setObjectRotation;

_USBInterface set [0, _object];
private _interfaces = _computer getVariable "AE3_USB_Interfaces";
_interfaces set [_name, _USBInterface];

_object setVariable ['AE3_Flashdrive_Parent', _computer];
_object setVariable ['AE3_Flashdrive_Interface', _USBInterface];

[_object, "AE3_Flashdrive_takeEH", {
	params['_flashdrive', '_player'];

	private _computer = _flashDrive getVariable 'AE3_Flashdrive_Parent';
	private _USBInterface = _flashDrive getVariable 'AE3_Flashdrive_Interface';

	[_computer, _player, _USBInterface] call AE3_flashdrive_fnc_disconnectFlashDrive;

	[_flashDrive, "AE3_Flashdrive_takeEH", _thisScriptedEventHandler] call BIS_fnc_removeScriptedEventHandler;

	true;
}] call BIS_fnc_addScriptedEventHandler;
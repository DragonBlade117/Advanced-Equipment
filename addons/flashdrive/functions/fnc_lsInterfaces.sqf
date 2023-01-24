/**
 * List all interfaces.
 * 
 * Arguments:
 * 0: Computer <OBJECT>
 *
 * Returns:
 * 0: Interfaces <[STRING]>
 */

params['_computer'];

private _interfaces = _computer getVariable ["AE3_USB_Interfaces", createHashMap];
private _occupiedList = _computer getVariable "AE3_USB_Interfaces_occupied";
private _mountedList = _computer getVariable "AE3_USB_Interfaces_mounted";

private _result = [[["USB Interfaces:"]]];

{
	_y params ['_index', '_name', '_rel_pos', '_rot_yaw', '_rot_pitch', '_rot_roll'];
	
	private _device = "";
	private _mountstr = "";

	private _occupied = _occupiedList select _index;
	private _mounted = _mountedList select _index;
	if (isNull _occupied) then
	{
		_device = "None";
	}else
	{
		_device = "Flash Drive";
	};

	if (_mounted) then
	{
		_mountstr = "mounted";
	};

	_result pushBack [[format ["%1 -  %2", _x, _device]], [format ["    %1", _mountstr],"#8ce10b"]];
} forEach _interfaces;

_result;
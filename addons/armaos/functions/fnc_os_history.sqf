/**
 * Lists/outputs the last commands of a given terminal on a given computer.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Options <[STRING]>
 * 2: Command Name <STRING>
 *
 * Results:
 * None
 */

params ["_computer", "_options", "_commandName"];

private _commandOpts =
[
		["_clear", "c", "", "bool", false, false, "clears the history list"],
        ["_deleteAtOffset", "d", "", "number", -1, false, "deletes a history entry at the given position offset"]
];
private _commandSyntax =
[
	[
			["command", _commandName, true, false],
			["options", "OPTIONS", false, false]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

private _terminal = _computer getVariable "AE3_terminal";

private _terminalCommandHistory = _terminal get "AE3_terminalCommandHistory";

if (_clear) exitWith
{
	_terminalCommandHistory = [];
	_terminal set ["AE3_terminalCommandHistory", _terminalCommandHistory];

	[_computer, "history cleared"] call AE3_armaos_fnc_shell_stdout;
};

if ((_deleteAtOffset != -1) && (_deleteAtOffset != 0) && !(_deleteAtOffset > (count _terminalCommandHistory))) exitWith
{
	_terminalCommandHistory deleteAt (_deleteAtOffset - 1);
	_terminal set ["AE3_terminalCommandHistory", _terminalCommandHistory];

	[_computer, format ["history element at index %1 deleted", _deleteAtOffset]] call AE3_armaos_fnc_shell_stdout;
};

private _numberedHistory = [];
{
	_numberedHistory pushBack (format ["%1: %2", (_forEachIndex + 1), _x]);
} forEach _terminalCommandHistory;

[_computer, _numberedHistory] call AE3_armaos_fnc_shell_stdout;
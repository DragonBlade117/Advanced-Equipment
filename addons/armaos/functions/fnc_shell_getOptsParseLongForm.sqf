params ["_longOpt", "_commandOpts"];

private _result = createHashMap;

// remove the leading "--"
_longOpt = _longOpt select [2, (count _longOpt) - 2];

// split into option and argument, if existing
([_longOpt] call AE3_armaos_fnc_shell_getOptsSplitOptionArgument) params ["_longOptWithoutArg", "_arg"];

private _searchArray = [_commandOpts, "long"] call AE3_armaos_fnc_shell_getOptsCreateSearchArray;
private _searchIndex = _searchArray find _longOptWithoutArg;

if (_searchIndex != -1) then
{
    private _longOptSettings = _commandOpts select _searchIndex;

    _result set ([_longOptSettings, _arg] call AE3_armaos_fnc_shell_getOptsConvertArgType);
};

_result;
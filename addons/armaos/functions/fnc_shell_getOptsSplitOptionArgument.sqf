params ["_opt"];

// split into option and argument, if existing
private _optSegments = _opt splitString "=";
private _optWithoutArg = _optSegments select 0;
private _arg = "";
if ((count _optSegments) >= 2) then { _arg = _optSegments select 1; };

[_optWithoutArg, _arg];
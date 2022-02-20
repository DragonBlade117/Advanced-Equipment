params ["_module", "_syncedUnits"];

private _syncedObjects = synchronizedObjects _module;

private _path = _module getVariable ['AE3_ModuleFilesystem_Path', ''];
private _content = _module getVariable ['AE3_ModuleFilesystem_FileContent', ''];
private _isFunction = _module getVariable ['AE3_ModuleFilesystem_IsFunction', ''];
private _owner = _module getVariable ['AE3_ModuleFilesystem_FileOwner', ''];

if(_path isEqualTo '') exitWith {};

if(_isFunction) then
{
	_content = compile _content;
};

[_syncedObjects, _path, _content, _owner] spawn 
{
	params ['_syncedObjects', '_path', '_content', '_owner'];

	waitUntil { !isNil "BIS_fnc_init" };

	{
		[
			[],
			_x getVariable 'AE3_filesystem',
			_path,
			_content,
			'root',
			_owner
		] call AE3_filesystem_fnc_createFile;
	} forEach _syncedObjects;
};
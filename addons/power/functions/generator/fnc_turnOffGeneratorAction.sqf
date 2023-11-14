/*
 * Turns off the generator.
 *
 * Arguments:
 * 0: Generator <OBJECT>
 * 1: If the ace progress bar is shown <BOOL>
 * 
 * Return:
 * None
*/

params ["_entity", ["_silent", false]];

private _result = false;

private _stopSoundHandle = scriptNull;

private _turnOffGenFunc =
{
	params ["_entity", "_stopSoundHandle"];

	[_entity, "turnedOn", false] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];
	[_entity] remoteExecCall ["AE3_power_fnc_removeProviderHandler", 2];

	_stopSoundHandle = [_entity] spawn AE3_power_fnc_playGeneratorStopSound;

	// TODO: Wrapper?
	{
			[_x] call (_x getVariable "AE3_power_fnc_turnOffWrapper");
	}forEach (_entity getVariable ["AE3_power_connectedDevices", []]);
};

if ((!isNull curatorCamera) || (_silent)) then
{
	[_entity] call _turnOffGenFunc;

	_result = true;
}
else
{
	private _turnOffTime = 3;

	[
		_turnOffTime,
		[_entity, _stopSoundHandle, _turnOffGenFunc], 
		{
			// following code only runs on progress bar success
			params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
			
			_args params ["_entity", "_stopSoundHandle", "_turnOffGenFunc"];

			[_entity, _stopSoundHandle] call _turnOffGenFunc;

			// we need to set power state here because function already returned false
			// and therefore the turn on wrapper doesn't set the state to turned on
			_entity setVariable ["AE3_power_powerState", 0, true];
		},
		{
			// following code only runs on progress bar fail
			params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
			
			_args params ["_entity", "_stopSoundHandle", "_turnOffGenFunc"];

			// stop sound will be canceled
			terminate _stopSoundHandle;

			// start sound will be played
			private _startSoundHandle = [_entity] spawn AE3_power_fnc_playGeneratorStartSound;			
		},
		(localize "STR_AE3_Power_Interaction_TurnOff" + "...")
	] call ace_common_fnc_progressBar;
};

// function immediately returns false, because progress bar runs unscheduled
_result;
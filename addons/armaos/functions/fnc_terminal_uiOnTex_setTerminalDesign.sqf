params ["_computer", "_bgColorHeader", "_bgColorConsole", "_fontColorHeader", "_fontColorConsole"];

private _uiOnTexActive = _computer getVariable ["AE3_UiOnTexActive", false]; // local variable on computer object is sufficient

if (!_uiOnTexActive) then { [_computer] spawn AE3_armaos_fnc_terminal_uiOnTex_init; };

waitUntil { !isNull findDisplay "AE3_UiOnTexture" };

private _uiOnTextureDisplay = findDisplay "AE3_UiOnTexture";

private _uiOnTextureHeaderBackgroundCtrl = _uiOnTextureDisplay displayCtrl 900;
private _uiOnTextureConsoleBackgroundCtrl = _uiOnTextureDisplay displayCtrl 910;

private _uiOnTextureHeaderCtrl = _uiOnTextureDisplay displayCtrl 1000;
private _uiOnTextureConsoleCtrl = _uiOnTextureDisplay displayCtrl 1100;

private _uiOnTextureLanguageButtonCtrl = _uiOnTextureDisplay displayCtrl 1310;
private _uiOnTextureDesignButtonCtrl = _uiOnTextureDisplay displayCtrl 1320;
private _uiOnTextureBatteryButtonCtrl = _uiOnTextureDisplay displayCtrl 1050;
private _uiOnTextureCloseButtonCtrl = _uiOnTextureDisplay displayCtrl 1300;

_uiOnTextureHeaderBackgroundCtrl ctrlSetBackgroundColor _bgColorHeader;
_uiOnTextureConsoleBackgroundCtrl ctrlSetBackgroundColor _bgColorConsole;

_uiOnTextureHeaderCtrl ctrlSetTextColor _fontColorHeader;
_uiOnTextureLanguageButtonCtrl ctrlSetTextColor _fontColorHeader;
_uiOnTextureDesignButtonCtrl ctrlSetTextColor _fontColorHeader;
_uiOnTextureBatteryButtonCtrl ctrlSetTextColor _fontColorHeader;
_uiOnTextureCloseButtonCtrl ctrlSetTextColor _fontColorHeader;

_uiOnTextureConsoleCtrl ctrlSetTextColor _fontColorConsole;

displayUpdate _uiOnTextureDisplay;
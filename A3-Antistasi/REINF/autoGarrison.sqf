if (!isServer and hasInterface) exitWith {};

private ["_markerX","_destinationX","_originX","_groups","_soldiers","_vehiclesX","_size","_group","_truckX","_tam","_roads","_road","_pos"];

_markerX = _this select 0;
if (not(_markerX in smallCAmrk)) exitWith {};

_destinationX = getMarkerPos _markerX;
_originX = getMarkerPos respawnTeamPlayer;

_groups = [];
_soldiers = [];
_vehiclesX = [];

_size = [_markerX] call A3A_fnc_sizeMarker;

_divisor = 50;

if (_markerX in airportsX) then {_divisor = 100};

_size = round (_size / _divisor);

if (_size == 0) then {_size = 1};

_typeGroup = [groupsSDKmid,groupsSDKAT,groupsSDKSquad,groupsSDKSniper];

while {(_size > 0)} do
	{
	_typeGroup = selectRandom _typeGroup;
	_formatX = [];
	{
	if (random 20 <= skillFIA) then {_formatX pushBack (_x select 1)} else {_formatX pushBack (_x select 0)};
	} forEach _typeGroup;
	_group = [_originX, teamPlayer, _formatX,false,true] call A3A_fnc_spawnGroup;
	if !(isNull _group) then
		{
		_groups pushBack _group;
		{[_x] spawn A3A_fnc_FIAinit; _soldiers pushBack _x} forEach units _group;
		_Vwp1 = _group addWaypoint [_destinationX, 0];
		_Vwp1 setWaypointType "MOVE";
		_Vwp1 setWaypointBehaviour "AWARE";
		sleep 30;
		};
	_size = _size - 1;
	};

waitUntil {sleep 1;((not(_markerX in smallCAmrk)) or (lados getVariable [_markerX,sideUnknown] == Occupants) or (lados getVariable [_markerX,sideUnknown] == ))};
/*
{_vehiculo = _x;
waitUntil {sleep 1; {_x distance _vehiculo < distanceSPWN} count (allPlayers - (entities "HeadlessClient_F")) == 0};
deleteVehicle _vehiculo;
} forEach _vehiclesX;*/
{_soldierX = _x;
waitUntil {sleep 1; {_x distance _soldierX < distanceSPWN} count (allPlayers - (entities "HeadlessClient_F")) == 0};
deleteVehicle _soldierX;
} forEach _soldiers;
{deleteGroup _x} forEach _groups;
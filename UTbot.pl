:-dynamic navigation/2, navPoint/3, prevLocation/3, self/3, orientation/3, status/2, score/3, currentWeapon/2, weapon/3,
	powerup/2, armor/4, fragged/4, path/4, logic/1, pickup/3, base/2, game/4, teamScore/2, flagState/2, item/4,
	bot/6, pickup/1, slowVolume/1, getItem/1 ,captureFlag/0,flagState/2, flag/3, look/1, shoot/1, enemyBaseLocation/1, 
	ourBaseLocation/1, lastKnownLocFlag/1, base/2, bot/6, deployable/1, goLocation/1, inRadius/1, pickup/0, escort/0, killModus/0.
	goLocationFlag/1, helpDef/2, goLocationHelp/1, goLocationHome/1, goLocationFlagEnemy/1.

	
radius(1000).

	
	% We are at a certain location if the IDs match, or ...
	at(UnrealID) :- navigation(reached,UnrealID).
	
	% ... if the coordinates are approximately equal.
	at(location(X,Y,Z)) :- navigation(reached,location(X1,Y1,Z1)), 
	round(X) =:= round(X1), round(Y) =:= round(Y1), round(Z) =:= round(Z1). 
	
	% Fragged predicate to adopt suitable goals.
    	fraggedBot(ID):- fragged(_, _, ID, _).
	
	% enemy bot
	enemyBot(UnrealID, Location) :-
		bot(UnrealID,_,Team,Location,_,_),
		self(_,_,Team2),
		Team \= Team2.
		
	%checks if a player is holding a flag.
	holdingFlag :- flag(Team2,Player,_), self(Player,_,Team).
	
	%Gives the dropped flag location.
	droppedFlagAt(Location) :- flagState(Team,'dropped'), flag(Team,_,Location).
	droppedFlagAt(Loc):-lastKnownLocFlag(Loc).
	
	% A:weapon the bot sees B: current wapen ( We can still discuss the order - Fays )
	betterWeapon(A,B) :- better(A,B,[shock_rifle,flak_cannon,link_gun,stinger_minigun,sniper_rifle,enforcer,impact_hammer]).
	better(A,B,[X|T]) :- A = X, not(B=X).
	better(A,B,[X|T]) :- not(A=X), not(B=X), better(A,B,T).


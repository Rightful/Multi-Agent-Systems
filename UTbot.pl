:-dynamic navigation/2, navPoint/3, prevLocation/3, self/3, orientation/3, status/2, score/3, currentWeapon/2, weapon/3,
	powerup/2, armor/4, fragged/4, path/4, logic/1, pickup/3, base/2, game/4, teamScore/2, flagState/2, item/4,
	bot/6, pickup/1, slowVolume/1, getItem/1 ,captureFlag/0,flagState/2, flag/3, look/1, shoot/1, enemyBaseLocation/1, 
	ourBaseLocation/1, lastKnownLocFlag/1, base/2, bot/6, deployable/1, goLocation/1, inRadius/1, pickup/0, escort/0, killModus/0, 
	angle/3, viewAngle/1, lastAngleUpdater/1, ownLocation/3, lookingAt/1, lastFlag/3, goLocationFlag/1, inRadius/1, 
	helpDef/2, goLocationHelp/1, goLocationHome/1, goLocationFlagEnemy/1, weaponSelected/0, fraggedBot/2, fraggedBot/1, goEscort/1, 
	goHomeWithFlag/1, goLastKnown/1, locationOfFlag/3.

	
radius(1000).

	% Getting the next time for updating look action.
	timeForUpdate :- 
		lastAngleUpdater(LastAngleUpdateTime), 
		get_time(CurrentTime),
		NextTime is LastAngleUpdateTime+0.3,
		CurrentTime > NextTime.

	% Calculate the next angle.
	nextAngle(NextAngleX) :-
		viewAngle(PreviousAngleX),
		NextAngleX is mod(PreviousAngleX+90,360).
		
	% Point from our location.
	lookAt(location(X, Y, CZ), Ax) :-
		ownLocation(CX, CY, CZ),
		nextAngle(Ax),
		angle(Ax,Sin,Cos),
		X is (1024*Cos)+CX,
		Y is (1024*Sin)+CY.
	
	% We are at a certain location if the IDs match, or ...
	at(UnrealID) :- navigation(reached,UnrealID).
	
	% ... if the coordinates are approximately equal.
	at(location(X,Y,Z)) :- navigation(reached,location(X1,Y1,Z1)), 
	round(X) =:= round(X1), round(Y) =:= round(Y1), round(Z) =:= round(Z1). 
	
	fraggedBot(ID):- fraggedBot(ID,location(X,Y,Z)).
	% Fragged predicate to adopt suitable goals.
    	fraggedBot(ID, location(X,Y,Z)):- fragged(_, _, ID, _).
	
	% Distance predicate that calculates the 3D distance between 2 bots in Unreal Units
	distance(X,Y,Z,X1,Y1,Z1,D) :- DX is (X-X1), DY is (Y-Y1), DZ is (Z-Z1), Xsq is (DX*DX), Ysq is (DY*DY), Zsq is (DZ*DZ),
		XYsum is Xsq+Ysq, XYZsum is XYsum+Zsq, D is sqrt(XYZsum).

	% enemy bot
	enemyBot(UnrealID, Location) :-
		bot(UnrealID,_,Team,Location,_,_),
		self(_,_,Team2),
		Team \= Team2.
		
	%checks if a player is holding a flag.
	holdingFlag :- flag(Team2,Player,_), self(Player,_,Team), Team \= Team2.
	
	%Gives the dropped flag location.
	droppedFlagAt(Location) :- flagState(Team,'dropped'), flag(Team,_,Location).
	droppedFlagAt(Loc):-lastKnownLocFlag(Loc).
	
	% A:weapon the bot sees B: current wapen ( We can still discuss the order - Fays )
	betterWeapon(A,B) :- better(A,B,[shock_rifle,flak_cannon,link_gun,stinger_minigun,sniper_rifle,enforcer,impact_hammer]).
	better(A,B,[X|T]) :- A = X, not(B=X).
	better(A,B,[X|T]) :- not(A=X), not(B=X), better(A,B,T).


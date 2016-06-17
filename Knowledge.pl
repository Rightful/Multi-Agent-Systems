:-dynamic 
	navigation/2, 		%
	navPoint/3,
	self/3,
	orientation/3,
	lookingAt/1,
	status/2,
	%score/3,
	currentWeapon/2,
	weapon/3,
	atkRad/1, 
	powerup/2,
	armor/4,
	fragged/4,
	pickup/3,
	base/2,
	flagState/2, 
	item/4,
	bot/6,
	pickup/1,
	flag/3,
	enemyBaseLocation/1, 
	ourBaseLocation/1,
	base/2,
	bot/6,
	goLocation/1,
	inRadius/1,		%inRadius(
	angle/3,		%angle(Angle, Sinus, CoSinus)
	viewAngle/1,
	lastAngleUpdater/1,
	ownLocation/3, 
	lookingAt/1,
	goLocationFlag/1,
%	goLocationHelp/2, 
	goLocationFlagEnemy/1,
	goHomeWithFlag/1,
	goRandom/1,
	goLocationHelp/1,
	goLocationKill/1,
	%goToEnemyBase/1, 
	closeToEnemyBaseNavPoint/1,
	closeToOurBaseNavPoint/1.

	% Radius of defender which to navigate.
	radius(1000).

	% Getting the next time for updating look action.
	timeForUpdate :- 
		lastAngleUpdater(LastAngleUpdateTime), 
		get_time(CurrentTime),
		NextTime is LastAngleUpdateTime+0.5,
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
	
	% If opponentflag is not home.
	 enemyFlagNotHome :- self(_,_,Team), not(flagState(Team2,'home')), Team\=Team2.
	 	
	% If the coordinates are approximately equal.
	at(location(X,Y,Z)) :- navigation(reached,location(X1,Y1,Z1)), 
	round(X) =:= round(X1), round(Y) =:= round(Y1), round(Z) =:= round(Z1). 
	
	% Fragged predicate to adopt suitable goals.
    	%fraggedBot(ID, location(X,Y,Z)):- fragged(_, _, ID, _).

	% Enemy bot
	enemyBot(UnrealID, Location) :-
		bot(UnrealID,_,Team,Location,_,_),
		self(_,_,Team2),
		Team \= Team2.
		
	% Checks if a player is holding a flag.
	holdingFlag :- flag(Team2,Player,_), self(Player,_,Team), Team \= Team2.
	
	% Gives the dropped flag location.
	droppedFlagAt(Location) :- flagState(Team,'dropped'), flag(Team,_,Location).
	
	% A: weapon the bot sees | B: current weapon we have.
	betterWeapon(A,B) :- better(A,B,[shock_rifle,flak_cannon,link_gun,stinger_minigun,enforcer,sniper_rifle,impact_hammer]).
	better(A,B,[X|T]) :- A = X, not(B=X).
	better(A,B,[X|T]) :- not(A=X), not(B=X), better(A,B,T).


:-dynamic navigation/2, navPoint/3, self/3, orientation/3, status/2, score/3, currentWeapon/2, weapon/3,
	powerup/2, armor/4, fragged/4, path/4, logic/1, pickup/3, base/2, game/4, teamScore/2, flagState/2, item/4,
	bot/6, pickup/1, slowVolume/1, keepMoving/0, getHp/0, getItem/1, setWeapPref/0, kill/2, shoot/1,pickedUp/1,
	prevLocation/3, look/1, goTo/1, resetLook/0.

	
% If the bot's hp is not full, it needs Hp.
hpNeeded :- status(Hp,Armor), Hp < 100.

% If the bot's hp is 60 or less, it should prioritize staying alive.
survive :- status(Hp,Armor), Hp =< 40.

% Calculates the 3D distance between 2 bots or objects.
distance(X1,Y1,Z1,X,Y,Z,D) :- Xdif is (X1-X), Ydif is (Y1-Y), Zdif is (Z1-Z), Xsq is (Xdif*Xdif), Ysq is (Ydif*Ydif), Zsq is (Zdif*Zdif),
	InterSum is Xsq+Ysq, Sum is InterSum + Zsq, D is sqrt(Sum).

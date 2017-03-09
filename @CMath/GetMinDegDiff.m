function Deg_Diff = GetMinDegDiff( Obj, Deg_In1, Deg_In2 )
% GetMinDegDiff - Calculate degree difference
%
% 	Deg_Diff = Obj.GetMinDegDiff( Deg_In1, Deg_In2 )
% 	Input:
% 		Deg_In1, Deg_In2: Please mod to 360.
% 			Deg_In2 chould be an array or a single value
% 	Output:
% 		Deg_diff:  Deg_In1 - Deg_In2, Output will be in range -180 ~ 180
	Deg_Diff = Deg_In1 - Deg_In2;
	bIsOutRange = abs( Deg_Diff ) > 180.0;
	Deg_Diff( bIsOutRange ) = Deg_Diff( bIsOutRange ) - sign( Deg_Diff( bIsOutRange ) ) * 360;
end

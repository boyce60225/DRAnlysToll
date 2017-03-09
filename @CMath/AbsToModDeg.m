function DegRaw = AbsToModDeg( Obj, DegRaw )
% AbsToModDeg - Convert raw deg to modulo 360 degree
%
% 	DegOut = Obj.AbsToModDeg( DegIn )
	DegRaw = mod( DegRaw, 360 );
end % End of AbsToModDeg

function AngleSpan = GetCornerDeg( Obj, v1, v2 )
% GetCornerDeg - Compute corner angle of consecutive vector ( v1 to v2 )
%
% 	AngleSpan = Obj.GetCornerDeg( v1, v2 )
	v3 = v1 + v2;
	Len1 = norm( v1 );
	Len2 = norm( v2 );
	Len3 = norm( v3 );
	% Check whether denominator is zero
	if Len1 * Len2 ~= 0
		AngleSpan = acos( ( Len1 ^ 2 + Len2 ^ 2 - Len3 ^ 2 ) / ( 2 * Len1 * Len2 ) );
	else
		AngleSpan = pi;
	end

	% Change unit from rad to deg
	AngleSpan = AngleSpan * Obj.zToDeg;
end % End of

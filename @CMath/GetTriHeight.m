function vHeight = GetTriHeight( Obj, v1, v2 )
% GetTriHeight - Compute height of triangle composed of vector v1, v2
%
% 	vHeight = Obj.GetTriHeight( v1, v2 )
% 	Example: v1 = [ 1, 1 ], v2 = [ 2, 0 ]
% 		then vHeight = [ 0, 1 ]
	Len1 = norm( v1 );
	Len2 = norm( v2 );
	Dot_v1v2 = sum( v1 .* v2 );
	LenProj_v1 = Dot_v1v2 / Len2;
	vProj_v1 = v2 * LenProj_v1 / Len2;
	vHeight = v1 - vProj_v1;
end % End of GetTriHeight

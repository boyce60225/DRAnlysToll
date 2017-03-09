function DegRaw = ModToAbsDeg( Obj, DegRaw )
% ModToAbsDeg - Convert raw deg ( modulo 360 ) to contiuous deg
%
% 	DegOut = Obj.ModToAbsDeg( DegIn )
	nLen = length( DegRaw );
	if nLen > 2
		% Find Jump Index
		nIdx = find( abs( diff( DegRaw ) ) > 180.0 );
		for i = 1 : length( nIdx )
			DegRaw( nIdx( i ) + 1 : end ) = ...
				+ DegRaw( nIdx( i ) + 1 : end ) ...
				- sign( DegRaw( nIdx( i ) + 1 ) - DegRaw( nIdx( i ) ) ) * 360;
		end
	end
end % End of ModToAbsDeg

classdef CMath
	properties ( GetAccess = 'public', SetAccess = 'private' )
		mCurv = CCurve.empty();
	end % End of properties
	methods
		function DegRaw = ModToAbsDeg( Obj, DegRaw )
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

		function [] = MovingAverage( Obj, nQueSize )
		% MovingAverage -
		end % End of MovingAverage

		function [] = SectionSmooth( Obj, ErrAllow,  )
		%
		end

	end % End of methods
end % End of classdef

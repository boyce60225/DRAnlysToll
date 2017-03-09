classdef CCurve
	properties ( GetAccess = 'public', SetAccess = 'private' )
	end
	methods
		function Obj = CCurve()
		% CCurve - Constructor of CCurve object
		%
		% 	Obj = CCurve()
		end % End of CCurve Constructor

		[ X, Y ] = Bezier( varargin )
		% Bezier - Output bezier curve

		
	end % End of methods
end % End of classdef

classdef CMath
	properties ( GetAccess = 'public', SetAccess = 'private' )
		mCurv = CCurve;
	end % End of properties
	properties ( Constant )
		zToDeg = 180.0 / pi;
		zToRad = pi / 180.0;
		zToInch = 1.0 / 25.4;
		zToMM = 25.4;
	end % End of properties
	methods
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

		function DegRaw = AbsToModDeg( Obj, DegRaw )
		% AbsToModDeg - Convert raw deg to modulo 360 degree
		%
		% 	DegOut = Obj.AbsToModDeg( DegIn )
			DegRaw = mod( DegRaw, 360 );
		end % End of AbsToModDeg

		function vHeight = GetTriHeight( Obj, v1, v2 )
		% GetTriHeight
			Len1 = norm( v1 );
			Len2 = norm( v2 );
			Dot_v1v2 = sum( v1 .* v2 );
			LenProj_v1 = Dot_v1v2 / Len2;
			vProj_v1 = v2 * LenProj_v1 / Len2;
			vHeight = v1 - vProj_v1;
		end % End of GetTriHeight

		function [] = MovingAverage( Obj, nQueSize )
		% MovingAverage -
		end % End of MovingAverage

		function varargout = TrajSmooth( Obj, sMethod, varargin )
		% TrajSmooth - Smooth trajectory based on sMethod

			% Do smooth process
			switch sMethod
			case 'SectionCut'
				nAxInput = length( varargin );
				nAxRequire = 2;
				nCount = length( varargin{ 1 } );
				varargout = cell( nAxRequire, 1 );
				for i = 1 : nAxRequire
					varargout{ i } = zeros( 2 * nCount - 1, 1 )
				end
				Pole =  0 : ( pi / 2 ) : ( ( 2 * nCount - 1 ) * pi / 2 );
				Odd = abs( cos( Pole ) );
				Even = abs( sin( Pole ) );
				for i = 2 : n - 1

				end

			case 'Interpolation'
				% varargin{ 1 }: Index of trim point
				% varargin{ 2 ~ 3 }: Axis input
				disp( 'Executing trajectory smooth: Interpolation' );
				nAxInput = length( varargin ) - 1;
				nAxRequire = 2;
				nCount = length( varargin{ 1 } );
				for i = 1 : nCount
					Idx = varargin{ 1 }( i );
					t = [ ...
						varargin{ 2 }( Idx - 1 ); ...
						varargin{ 2 }( Idx + 1 ) ];
					y = [ ...
						varargin{ 3 }( Idx - 1 ); ...
						varargin{ 3 }( Idx + 1 ) ];
					varargin{ 3 }( Idx ) = interp1( t, y, varargin{ 2 }( Idx ) );
				end
				varargout = { varargin{ 2 }; varargin{ 3 } };

			otherwise
				disp( 'No match method' );
			end
		end % End of TrajSmooth

	end % End of methods
end % End of classdef

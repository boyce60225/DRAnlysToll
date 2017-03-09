function varargout = TrajSmooth( Obj, sMethod, varargin )
% TrajSmooth - Smooth trajectory based on sMethod
%
% 	Obj.TrajSmooth( sMethod, ... )
% 	Input:
% 		sMethod:
% 			'SectionCut'
% 			'PolyEstimation'
% 			'Interpolation'
	% Do smooth process
	switch sMethod
	case 'SectionCut'
		% 0.8 0.2 | 0.6 0.2 | 0.6 0.2 ratio combination
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

	case 'PolyEstimation'
		% varargin{ 1 }: Index of trim point
		% varargin{ 2 }: Order of polynomial
		% varargin{ 3 ~ 4 }: Axis input
		disp( 'Executing trajectory smooth: PolyEstimation' );
		nAxInput = length( varargin ) - 2;
		nAxRequire = 2;
		nCount = length( varargin{ 1 } );
		nIdxIni = zeros( nCount, 1 );
		nIdxEnd = zeros( nCount, 1 );
		% Grouping process
		nGroup = 1;
		for i = 1 : nCount
			Idx = varargin{ 1 }( i );
			if nIdxIni( nGroup ) == 0
				nIdxIni( nGroup ) = Idx;
				nIdxEnd( nGroup ) = Idx;
			else
				if ( Idx - nIdxEnd( nGroup ) ) ~= 1
					nGroup = nGroup + 1;
					nIdxIni( nGroup ) = Idx;
				end
				nIdxEnd( nGroup ) = Idx;
			end
		end
		% Do trajectory smooth process
		% Polynomial 3rd order
		for i = 1 : nGroup
			t_Ini = varargin{ 3 }( nIdxIni( i ) - varargin{ 2 } );
			t = [ ...
				varargin{ 3 }( nIdxIni( i ) - varargin{ 2 } : nIdxIni( i ) - 1 ); ...
				varargin{ 3 }( nIdxEnd( i ) + 1 : nIdxEnd( i ) + varargin{ 2 } ) ];
			t = t - t_Ini;
			y = [ ...
				varargin{ 4 }( nIdxIni( i ) - varargin{ 2 } : nIdxIni( i ) - 1 ); ...
				varargin{ 4 }( nIdxEnd( i ) + 1 : nIdxEnd( i ) + varargin{ 2 } ) ];
			p = polyfit( t, y, 3 );
			t_Fix = varargin{ 3 }( nIdxIni( i ) : nIdxEnd( i ) ) - t_Ini;
			y_Fix = polyval( p, t_Fix );
			varargin{ 4 }( nIdxIni( i ) : nIdxEnd( i ) ) = y_Fix( : );
		end
		varargout = { varargin{ 3 }; varargin{ 4 } };

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

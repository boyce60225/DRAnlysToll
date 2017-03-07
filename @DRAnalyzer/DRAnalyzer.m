classdef DRAnalyzer
% DRAnalyzer - DataRecorder analyzer
	properties ( GetAccess = 'public', SetAccess = 'private' )
		mMath = CMath();
	end
	methods
		function Obj = DRAnalyzer()
		% DRAnalyzer - Constructor of DRAnalyzer

		end % End of DRAnalyzer Constructor

		function varargout = AnlysAdjPath( Obj, hFunc, varargin )
		% AnlysAdjPath - Analyze on adjacent path
		%
		% 	[] = Obj.GetAdjPath( hFunc, Ax1, Ax2, ... )
		% 	Input:
		% 		Obj.GetAdjPath( @( C ) C - 90, CAxis, XAxis, YAxis )

			% Initialize
			nAxInput = length( varargin );
			nAxRequire = nargin( hFunc );
			% Check number of axis is enough for function handle
			if nAxInput >= nAxRequire
				% Construct function format
				sFormat = [ 'f = hFunc( varargin{ 1 }' ];
				for i = 2 : nAxRequire
					sFormat = [ sFormat, ', varargin{ 2 }' ];
				end
				sFormat = [ sFormat, ');' ];
				eval( sFormat );

				% Find sign change of f
				% ex: [ 2, -3, -4, 5 ]
				% nSignChgIdx = [ 1, 3 ]
				f( f >= 0 ) = 1;
				f( f < 0 ) = 0;
				nSignChgIdx = find( diff( f ) ~= 0 );

				% Do Interpolation to find exact point when crossing
				DataRaw = zeros( length( varargin{ 1 } ), nAxInput );
				Prev = DataRaw( nSignChgIdx, : );
				Next = DataRaw( nSignChgIdx + 1, : );
			else
			end
		end % End of AnlysAdjPath

		function varargout = AnlysNoisePt( Obj, sMethod, varargin )
		% AnlysNoisePt - Analyze noise point

			% Initialize, Construct function format
			nAxInput = length( varargin );

			% Analyze based on sMethod input
			switch sMethod
			case 'TriHeight'
				% 2D Analysis, noise is determine by triangle height
				% v1 = [ x1; y1 ], v2 = [ x2; y2 ] construct a triangle
				nAxRequire = 2;
				if nAxInput >= nAxRequire
					disp( 'Executing Noise Pt Analysis: TriHeight' );
					nCount = length( varargin{ 1 } );
					AnlysValue = zeros( nCount, 1 );
					for i = 3 : nCount
						v1 = [ ...
							varargin{ 1 }( i - 1 ) - varargin{ 1 }( i - 2 ); ...
							varargin{ 2 }( i - 1 ) - varargin{ 2 }( i - 2 )];
						v2 = [ ...
							varargin{ 1 }( i ) - varargin{ 1 }( i - 2 ); ...
							varargin{ 2 }( i ) - varargin{ 2 }( i - 2 ) ];
						AnlysValue( i - 1 ) = norm( Obj.mMath.GetTriHeight( v1, v2 ) );
					end
					varargout = { AnlysValue };
				else
					disp( 'Not Enough Input' );
				end
			end
		end % End of AnlysNoisePt
	end % End of methods
end % End of classdef

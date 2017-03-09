function varargout = AnlysNoisePt( Obj, sMethod, varargin )
% AnlysNoisePt - Analyze noise point
%
% 	Result = Obj.AnlysNoisePt( sMethod, Ax1, Ax2, ... )
% 	2D Analysis Method:
% 		'TriHeight': using pt i, i + 1, i + 2,
% 			construct v1 = pt( i + 1 ) - pt( i ), v2 = pt( i + 2 ) - pt( i )
% 			to compute height of triangle

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
			disp( 'Finish Noise Pt Analysis' );
		else
			disp( 'Not Enough Input' );
		end
	case 'TrajReverse'
		% 2D Analysis, noise is determine by trajectory reverse
	otherwise
		disp( 'No matching method' );
	end
end % End of AnlysNoisePt

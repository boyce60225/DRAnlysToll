function varargout = AnlysAdjPath( Obj, hFunc, varargin )
% AnlysAdjPath - Analyze adjacent path difference
%
% 	[ Index, AxOut1, AxOu2, ... ] = Obj.GetAdjPath( hFunc, AxIn1, AxIn2, ... )
% 	Input:
% 		hFunc: Function for Poincare plane
% 		hExeption: Function for exception test
% 		AxIn: Axis input
% 	Output:
% 		Index: Index when zero-crossing happened
% 		AxOut: Axis data when zero-crossing happened
% 	Example:
% 		hFunc = @( C ) mMath.GetDegDiff( C, 90 );
% 		hException = @( f_Prev, f_Curr ) ;
% 		Obj.GetAdjPath( @( C ) C - 90, @, CAxis, XAxis, YAxis )

	% Initialize
	nAxInput = length( varargin );
	nAxRequire = nargin( hFunc );
	% Check number of axis is enough for function handle
	if nAxInput >= nAxRequire
		% Construct function format
		sFormat = [ 'f_Raw = hFunc( varargin{ 1 }' ];
		for i = 2 : nAxRequire
			sFormat = [ sFormat, ', varargin{ 2 }' ];
		end
		sFormat = [ sFormat, ');' ];
		eval( sFormat );

		% Find sign change of f
		% ex: [ 2, -3, -4, 5 ]
		% nSignChgIdx = [ 1, 3 ]
		f = f_Raw;
		%f( f >= 0 ) = 1;
		%f( f < 0 ) = 0;
		for i = 1 : length( f ) - 1
			if ( f_Raw( i ) * f_Raw( i + 1 ) < 0 ) && abs( f_Raw( i ) - f_Raw( i + 1 ) ) < 180.0
				f( i ) = 1;
			else
				f( i ) = 0;
			end
        end
        f( end ) = 0;
		%nSignChgIdx = find( diff( f ) ~= 0 );
		nSignChgIdx = find( f ~= 0 );
		varargout{ 1 } = nSignChgIdx;

		% Do Interpolation to find exact point when crossing
		nLen = length( nSignChgIdx );
		for i = 1 : nLen
			d1 = abs( f_Raw( nSignChgIdx( i ) ) );
			d2 = abs( f_Raw( nSignChgIdx( i ) + 1 ) );
			for j = 1 : nAxInput
				value1 = varargin{ j }( nSignChgIdx( i ) );
				value2 = varargin{ j }( nSignChgIdx( i ) + 1 );
				valueOut = ( d1 * value2 + d2 * value1 ) / ( d1 + d2 );
				varargout{ j + 1 }( i ) = valueOut;
			end
		end
		%DataRaw = zeros( length( nSignChgIdx ), nAxInput );

		%Prev = DataRaw( nSignChgIdx, : );
		%Next = DataRaw( nSignChgIdx + 1, : );
	else
		disp( 'Not enough input axis' );
	end
end % End of AnlysAdjPath

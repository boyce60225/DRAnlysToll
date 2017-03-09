function varargout = AnlysGridGen( Obj, GridDim, GridSize, varargin )
% AnlysGridGen - Analyze raw data, then Generate grid
%
% 	[ X, Y, ZGrid ] = Obj.AnlysGridGen( GridDim, GridSize, Ax1, Ax2, Ax3, sMethod )
% 	Input:
% 		GridGeo: Grid Geometry [ Init Pt, Length in each dim ]
% 			For example, ( 1, 2 ) to ( 13, 14 ) 2D rectangle,
% 			GridDim = [ 1, 13; 2, 14 ]
% 		GridSize: Size of each grid
% 		Ax: Axis Input
% 		sMethod: method for hole mending
% 			'None': Default not mending
% 			'Gradient': Mending by gradient difference
% 			'Average': Mending by average neibor point

	% Initialize
	nAxInput = length( varargin );
	nAxRequire = 3; % ( GridAx )X, Y ( ValueAx )Z
	if nAxInput > 3 && ischar( varargin{ 4 } )
		sMethod = varargin{ 4 };
	else
		sMethod = 'None';
	end

	vInit = GridDim( :, 1 );
	vEnd = GridDim( :, 2 );
	vDiag = abs( vEnd - vInit );

	% Generate empty grid map
	nGridNum = ceil( vDiag ./ GridSize );
	GridOfValue = zeros( nGridNum( 1 ), nGridNum( 2 ) );
	GridOfAccum = GridOfValue;

	% Mapping GridAx to index
	nGridX = floor( ( varargin{ 1 } - vInit( 1 ) ) ./ GridSize( 1 ) ) + 1;
	nGridY = floor( ( varargin{ 2 } - vInit( 2 ) ) ./ GridSize( 2 ) ) + 1;

	% Check whether current point in GridDim rectangle
	bPtInRange = ...
	 	( ( nGridX > 0 ) & ( nGridX <= nGridNum( 1 ) ) ) & ...
		( ( nGridY > 0 ) & ( nGridY <= nGridNum( 2 ) ) );
	nIdx = find( bPtInRange );
	if isrow( nIdx ) == false
		nIdx = nIdx';
	end

	% Fill Grid with Axis input
	for i = nIdx
		GridOfValue( nGridX( i ), nGridY( i ) ) = GridOfValue( nGridX( i ), nGridY( i ) ) + varargin{ 3 }( i );
		GridOfAccum( nGridX( i ), nGridY( i ) ) = GridOfAccum( nGridX( i ), nGridY( i ) ) + 1;
	end

	% devide GridOfValue with GridOfAccum
	nIdx = find( GridOfAccum > 0 );
	GridOfValue( nIdx ) = GridOfValue( nIdx ) ./ GridOfAccum( nIdx );

	% Do mending process
	switch sMethod
	case 'Gradient'
		
	case 'Average'
		nOrder = varargin{ 5 };
		Kernel = ones( 3, 3 ) ./ 8;
		Kernel( 2, 2 ) = 0;
		GridOfNearAccum = conv2( GridOfAccum, Kernel, 'same' );
		Kernel = ones( nOrder, nOrder ) ./ ( nOrder ^ 2 - 1 );
		Kernel( ( nOrder + 1 ) / 2 , ( nOrder + 1 ) / 2 ) = 0;
		GridOfNearValue = conv2( GridOfValue, Kernel, 'same' );
		bPtInRange = ( GridOfAccum == 0 ) & ( GridOfNearAccum > 0 );
		GridOfValue( bPtInRange ) = GridOfNearValue( bPtInRange );
	otherwise
	% None
	end

	% Output result
	varargout{ 1 } = vInit( 1 ) : GridSize( 1 ) : vInit( 1 ) + nGridNum( 1 ) * GridSize( 1 );
	varargout{ 2 } = vInit( 2 ) : GridSize( 2 ) : vInit( 2 ) + nGridNum( 2 ) * GridSize( 2 );
	varargout{ 3 } = GridOfValue;
end % End of AnlysGridGen

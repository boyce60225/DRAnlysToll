function varargout = SortTrimData( Obj, RangeKeep, varargin )
% SortTrimData -

	% Initialize
	nAxInput = length( varargin );
	f = varargin{ 1 } >= RangeKeep( 1 ) && varargin{ 1 } <= RangeKeep( 2 ) ;
	Idx = find( f );
	for i = 1 : nAxInput
		varargout{ i } = varargin{ i }( f );
	end
end % End of SortTrimData

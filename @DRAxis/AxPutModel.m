function Obj = AxPutModel( Obj, nAxCode, hFunc, varargin )
% AxPutModel - Put modeled data into DRAxis object
%
% 	Obj = Obj.AxPutModel( nAxCode, hFunc, Ax1, Ax2 ... )
% 	Input:
% 		nAxCode:
% 		hFunc: Function handle
% 		Ax: DRAxis Object that needed

	% Initialize
	Obj.nAxCode = varargin{ 1 };
	Obj.hFunc = hFunc;

	% Check number of arguments
	nAxInput = length( varargin );
	nAxRequire = nargin( Obj.hFunc );
	if nAxInput < nAxRequire
		disp( 'Not enough input arguments' );
	else
		% Construct
		str = [ 'varargin{ 1 }' ];
		for i = 2 : nAxRequire
			str = [ str, ', varargin{ ', num2str( i ), ' }' ];
		end
		eval( [ 'Obj.CMD_Raw = Obj.hFunc( ', str, ' );' ] );
		Obj.nAxCount = length( Obj.CMD_Raw );
	end
end

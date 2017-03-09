function Obj = AxPutRaw( Obj, varargin )
% AxPutRaw - Put raw data into DRAxis object
%
% 	Obj = Obj.AxPutRaw( AxCMD, 'CMD', nAxCode )
% 	Obj = Obj.AxPutRaw( AxFBK, 'FBK', nAxCode )
% 	Obj = Obj.AxPutRaw( AxCMD, AxFBK, nAxCode )

	% Initialize
	if ischar( varargin{ 2 } )
		sMethod = varargin{ 2 };
	else
		sMethod = 'Both';
	end
	% Put data
	switch sMethod
	case 'Both'
		Obj.CMD_Raw = varargin{ 1 };
		Obj.FBK_Raw = varargin{ 2 };
		Obj.nAxCount = length( Obj.CMD_Raw );
	otherwise
		switch sMethod
		case 'CMD'
			Obj.CMD_Raw = varargin{ 1 };
			Obj.nAxCount = length( Obj.CMD_Raw );
		case 'FBK'
			Obj.FBK_Raw = varargin{ 1 };
			Obj.nAxCount = length( Obj.FBK_Raw );
		end
	end

	% Set AxCode if varargin{ 3 } exist
	if length( varargin ) > 2
		Obj.nAxCode = varargin{ 3 };
	else
		Obj.nAxCode = 1;
	end
end % End of AxPutRaw

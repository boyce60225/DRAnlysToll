function Obj = AxModify( Obj, varargin )
% AxModify - Modify value according to field name
%
% 	Obj = Obj.AxModify( 'sField1', Value1, 'sField2', Value2, ... )

	% Initialize
	nLen = length( varargin );
	if mod( nLen, 2 ) == 0
		nLen = nLen / 2.0;
		for i = 1 : nLen
			switch varargin{ i * 2 - 1 }
			case 'nAxCode'
				Obj.nAxCode = varargin{ i * 2 };
			case 'nAxType'
				Obj.nAxType = varargin{ i * 2 };
			case 'CrdShift'
				Obj.CrdShift = varargin{ i * 2 };
			case 'DisplayRatio'
				Obj.DisplayRatio = varargin{ i * 2 };
			otherwise
				disp( 'No match field, or direct set is not allowable' );
			end
		end
	else
		disp( 'Field does not have matched value' );
	end
end % End of AxModify

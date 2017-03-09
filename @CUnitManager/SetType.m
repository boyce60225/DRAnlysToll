function Obj = SetType( Obj, Type )
% SetType - Set unit type BLU, LIU, IU
%
% 	Obj = Obj.SetType( Type )
% 	Input:
% 		Type: [ 'BLU', 'LIU', 'IU' ]
	switch Type
	case 'BLU'
		Obj.NextMode.Type = 'BLU';
	case 'LIU'
		Obj.NextMode.Type = 'LIU';
	case 'IU'
		Obj.NextMode.Type = 'IU';
	end
	% Check mode modification
	if strcmp( Obj.CurrMode.Type, Obj.NextMode.Type ) == false
		% State change to unready
		Obj.nState( : ) = 0;
	end
end % End of SetType

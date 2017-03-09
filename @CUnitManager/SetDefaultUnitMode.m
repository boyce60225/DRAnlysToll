function Obj = SetDefaultUnitMode( Obj, Type, nDim, nPrec )
% SetDefaultUnitMode - Set unit current mode according to input
%
% 	Obj = Obj.SetDefaultUnitMode( Type, nDim, nPrec )

	% Set default NextMode
	Obj = Obj.SetUnitMode( Type, nDim, nPrec );
	% Do empty conversion
	for i = 1 : Obj.nDataNum
		Obj = Obj.DoIDUnitConv( i, [] );
	end
end % End of SetDefaultUnitMode

function Obj = SetUnitMode( Obj, Type, nDim, nPrec )
% SetUnitMode - Set unit next mode according to input
%
% 	Obj = Obj.SetUnitMode( Type, nDim, nPrec )
	Obj = Obj.SetType( Type );
	Obj = Obj.SetDim( nDim );
	Obj = Obj.SetPrec( nPrec );
end % End of SetUnitMode

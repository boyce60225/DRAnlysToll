function Obj = SetDim( Obj, nMode )
% SetDim - Set Metric( G70 ) \ Imperial( G71 ) dimension
%
% 	Obj = Obj.SetDim( nMode )
% 	Input:
% 		nMode: 70( Metric ) 71( Imperial )
	if nMode == 71
		Obj.NextMode.nDim = 71;
	else
		Obj.NextMode.nDim = 70;
	end
	% Check mode modification
	if ( Obj.CurrMode.nDim == Obj.NextMode.nDim ) == false
		% State change to unready
		Obj.nState( : ) = 0;
	end
end % End of SetDim

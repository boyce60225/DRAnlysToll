function Obj = SetPrec( Obj, nPrec )
% SetPrec - Set Pr17 precision
%
% 	Obj = Obj.SetPrec( nPrec )
% 	Input:
% 		nPrec: range( 1 ~ 3 ), default: 2
	if 1 <= nPrec && nPrec <= 3
		Obj.NextMode.nPrec = nPrec;
	else
		disp( 'Out of precision range' );
	end
	% Check mode modification
	if ( Obj.CurrMode.nPrec == Obj.NextMode.nPrec ) == false
		% State change to unready
		Obj.nState( : ) = 0;
	end
end % End of SetPrec

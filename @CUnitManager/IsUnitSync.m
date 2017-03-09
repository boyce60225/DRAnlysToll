function [ Obj, bIsSync ] = IsUnitSync( Obj )
% CheckUnitSync - Check whether all data sync to NextMode
%
% 	[ Obj, bIsSync ] = Obj.IsUnitSync()
	bIsSync = sum( Obj.nState ) >= Obj.nDataNum;
	% Sync CurrMode with NextMode
	if bIsSync == true
		Obj.CurrMode = Obj.NextMode;
	end
end % End of IsUnitSync

function [ LenRatio, RotRatio ] = GetBaseRatio( Obj, Mode )
% GetBaseRatio - Get base ratio according to Unit Mode
%
% 	BaseRatio = Obj.GetBaseRatio( Mode )
% 	Input:
% 		Mode: Could be Obj.CurrMode or Obj.NextMode
% 	Notice: 1.0e-4 mm ( or deg ) -> baseRatio == 1.0
	switch Mode.Type
	case 'IU'
		LenRatio = 1.0e4;
		RotRatio = 1.0e4;
	otherwise
	% LIU, BLU
		LenRatio = Obj.PrecRatio( Mode.nPrec );
		RotRatio = Obj.PrecRatio( Mode.nPrec );
	end

	% nDim: G70 G71
	switch Mode.nDim
	case 71
	% Imperial
		LenRatio = LenRatio * mMath.zToMM / 10.0;
	end
end % End of GetBaseRatio

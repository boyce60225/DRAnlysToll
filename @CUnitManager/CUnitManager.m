classdef CUnitManager
% CUnitManager - Data unit manager
%
% 	nDim - G70 G71, nPrec - Pr17
% 	G70	( Metric mm )
%	Pr17	IU		LIU			BLU
% 	1		mm		1e-2 mm		1 = 1e-2mm = 10um
% 					1e-2 deg
% 	2		mm		1e-3 mm		1 = 1e-3mm = 1um
% 					1e-3 deg
% 	3		mm		1e-4 mm 	1 = 1e-4mm = 0.1um
% 					1e-4 deg
% 	G71	( Imperial inch ) ~ 1 inch = 25.4 mm
% 	Pr17	IU		LIU			BLU
% 	1		inch	1e-3 inch 	1 = 1e-2mm = 10um
% 					1e-2 deg
% 	2		inch	1e-4 inch	1 = 1e-3mm = 1um
% 					1e-3 deg
% 	3		inch	1e-5 inch	1 = 1e-4mm = 0.1um
% 					1e-4 deg

	properties ( GetAccess = 'public', SetAccess = 'private' )
		nDataNum = 1;
		nState = [];
		CurrMode = struct( 'Type', 'BLU', 'nDim', 70, 'nPrec', 2 );
		NextMode = struct( 'Type', 'BLU', 'nDim', 70, 'nPrec', 2 );
		% Math module
		mMath = CMath.empty();
	end
	properties ( Constant )
		% For base ratio calculation
		PrecRatio = [ 100, 10, 1 ];
	end
	methods
		function Obj = CUnitManager( nDataNum, Type, nDim, nPrec )
		% CUnitManager - Constructor of unit manager object
		%
		% 	Obj = CUnitManager( nDataNum, 'Type', nDim, nPrec )
		% 	Input:
		% 		nDataNum:
		% 		'Type': Set all data unit mode as InitMode

			Obj.nDataNum = nDataNum;
			% Indicate all data in Ready state
			Obj.nState = 1 * ones( Obj.nDataNum, 1 );
			% Set default NextMode
			Obj = Obj.SetDefaultUnitMode( Type, nDim, nPrec );

		end % End of CUnitManager Constructor

		Obj = SetUnitMode( Obj, Type, nDim, nPrec )
		% SetUnitMode - Set unit next mode according to input

		Obj = SetDefaultUnitMode( Obj, Type, nDim, nPrec )
		% SetDefaultUnitMode - Set unit current mode according to input

		Obj = SetType( Obj, Type )
		% SetType - Set unit type BLU, LIU, IU

		Obj = SetDim( Obj, nMode )
		% SetDim - Set Metric( G70 ) \ Imperial( G71 ) dimension

		Obj = SetPrec( Obj, nPrec )
		% SetPrec - Set Pr17 precision

		[ LenRatio, RotRatio ] = GetBaseRatio( Obj, Mode )
		% GetBaseRatio - Get base ratio according to Unit Mode

		Data = DoUnitConv( Obj )
		% DoUnitConv - Do conversion according unit mode input

		[ Obj, Data ] = DoIDUnitConv( Obj, nDataID, Data, nAxType )
		% DoIDUnitConv - Do conversion at given Data ID

		[ Obj, bIsSync ] = IsUnitSync( Obj )
		% CheckUnitSync - Check whether all data sync to NextMode
		
	end % End of methods
end % End of classdef

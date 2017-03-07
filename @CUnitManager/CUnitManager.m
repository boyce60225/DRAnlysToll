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

		function Obj = SetUnitMode( Obj, Type, nDim, nPrec )
		% SetUnitMode - Set unit next mode according to input
		%
		% 	Obj = Obj.SetUnitMode( Type, nDim, nPrec )
			Obj = Obj.SetType( Type );
			Obj = Obj.SetDim( nDim );
			Obj = Obj.SetPrec( nPrec );
		end % End of SetUnitMode

		function Obj = SetDefaultUnitMode( Obj, Type, nDim, nPrec )
		% SetDefaultUnitMode
		%
		% 	Obj = Obj.SetDefaultUnitMode( Type, nDim, nPrec )

			% Set default NextMode
			Obj = Obj.SetUnitMode( Type, nDim, nPrec );
			% Do empty conversion
			for i = 1 : Obj.nDataNum
				Obj = Obj.DoIDUnitConv( i, [] );
			end
		end % End of SetDefaultUnitMode

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

		function Data = DoUnitConv( Obj )
		% DoUnitConv - Do conversion
		%
		% 	Data = Obj.DoUnitConv( Data, CurrMode, NextMode, nAxType )
		end

		function [ Obj, Data ] = DoIDUnitConv( Obj, nDataID, Data, nAxType )
		% DoIDUnitConv - Do conversion at given Data ID
		%
		% 	[ Obj, Data ] = Obj.DoIDUnitConv( nDataID, Data )
		% 	[ Obj, Data ] = Obj.DoIDUnitConv( nDataID, Data, 'Len' )
		% 	[ Obj, Data ] = Obj.DoIDUnitConv( nDataID, Data, 'Rot' )
		% 	Input:
		% 		nDataID: ID of specific data
		% 		Data: Data that do unit conversion

			% Initialize
			narginchk( 3, 4 );
			if nargin < 4
				nAxType = 'Len';
			end
			if ( Obj.nState( nDataID ) == 0 ) && ( isempty( Data ) == false )
				% Calculate base ratio
				Obj.CurrMode
				Obj.NextMode
				[ CurrLenRatio, CurrRotRatio ] = Obj.GetBaseRatio( Obj.CurrMode );
				[ NextLenRatio, NextRotRatio ] = Obj.GetBaseRatio( Obj.NextMode );
				% Do conversion
				switch nAxType
				case 'Len'
					ConvCoeff = CurrLenRatio / NextLenRatio;
					Data = Data .* ConvCoeff;
				case 'Rot'
					ConvCoeff = CurrRotRatio / NextRotRatio;
					Data = Data .* ConvCoeff;
				otherwise
					disp( 'Invalid Axis type input' );
				end
				% Change state to ready
				Obj.nState( nDataID ) = 1;
			else
				% Change state to ready
				Obj.nState( nDataID ) = 1;
			end
			% Check sync status
			Obj = Obj.IsUnitSync();
		end % End of DoIDUnitConv

		function [ Obj, bIsSync ] = IsUnitSync( Obj )
		% CheckUnitSync - Check whether all data sync to NextMode
		%
		% 	[ Obj, bIsSync ] = Obj.IsUnitSync()
			bIsSync = sum( Obj.nState ) >= Obj.nDataNum;
			if bIsSync == true
				Obj.CurrMode = Obj.NextMode;
			end
		end % End of IsUnitSync
	end % End of methods
end % End of classdef

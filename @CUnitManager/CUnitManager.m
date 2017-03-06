classdef CUnitManager
% CUnitManager - Data unit manager
%
% 	nDim - G70 G71, nPrec - Pr17
% 	G70	( Metric mm )
%	Pr17	IU		LIU			BLU
% 	1		mm		0.01mm		1 = 0.01mm = 10um
% 					0.01deg
% 	2		mm		0.001mm		1 = 0.001mm = 1um
% 					0.001deg
% 	3		mm		0.0001mm 	1 = 0.0001mm = 0.1um
% 					0.0001deg
% 	G71	( Imperial inch )
% 	Pr17	IU		LIU			BLU
% 	1		inch	1e-3 inch 	1 = 0.01mm = 10um
% 					1e-2 deg
% 	2		inch	1e-4 inch	1 = 0.001mm = 1um
% 					1e-3 deg
% 	3		inch	1e-5 inch	1 = 0.0001mm = 0.1um
% 					1e-4 deg

	properties ( GetAccess = 'public', SetAccess = 'private' )
		nDataNum = 1;
		nState = [];
		CurrMode = struct( 'Type', 'BLU', 'nDim', 70, 'nPrec', 2 );
		NextMode = strcut( 'Type', 'BLU', 'nDim', 70, 'nPrec', 2 );
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
			Obj = Obj.SetType( Type );
			Obj = Obj.SetDim( nDim );
			Obj = Obj.SetPrec( nPrec );
			% Do empty conversion
			for i = 1 : Obj.nDataNum
				Obj = Obj.DoUnitConv( i, [] );
			end

		end % End of CUnitManager

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
		end

		function varargout = DoUnitConv( Obj, varargin )
		% DoConv - Do conversion
		%
		% 	Obj = Obj.DoUnitConv( nDataID, Data )
		% 	Obj = Obj.DoUnitConv( Data )

			% 
			% Change state to ready
			Obj.nState( nDataID ) = 1;
		end % End of DoUnitConv

		function Obj = ChkUnitSync( Obj )
		% CheckUnitSync -
			for i = 1 : Obj.nDataNum
				Obj.nCurrMode
			end
		end % End of CheckUnitSync
	end
end

classdef DRAxis
% DRAxis - DataRecorder Axis Store
	properties ( GetAccess = 'public', SetAccess = 'private' )
		% Related to state ( 0: Wait update, 1: Up to date )
		nState = 0;
		hFunc = @( x ) x;
		% Related to plot
		Time = [];
		DisplayRatio = 1.0;
		% Axis data
		CMD_Pos = [];
		CMD_Vel = [];
		CMD_Acc = [];
		CMD_Jerk = [];
		CMD_Raw = [];
		FBK_Pos = [];
		FBK_Vel = [];
		FBK_Acc = [];
		FBK_Jerk = [];
		FBK_Raw = [];
		nAxCode = 0;
		nAxCount = 0;
		nAxType = 0;
		CrdShift = 0.0;
		% Unit Module ( CMD_Raw, FBK_Raw )
		mUnit = CUnitManager( 2, 'BLU', 70, 2 );
		% Math Module
		mMath = CMath;
		mCurv = CCurve;
	end
	methods
		function Obj = DRAxis( varargin )
		% DRAxis - Constructor of object DRAxis
		%
		% 	Obj = DRAxis( AxCMD, 'CMD', nAxCode )
		% 	Obj = DRAxis( AxFBK, 'FBK', nAxCode )
		% 	Obj = DRAxis( AxCMD, AxFBK, nAxCode )

			% Initialize
			narginchk( 2, 3 );

			if nargin > 2
				Obj = Obj.AxPutRaw( varargin{ 1 }, varargin{ 2 }, varargin{ 3 } );
			else
				Obj = Obj.AxPutRaw( varargin{ 1 }, varargin{ 2 }, 1 );
			end

		end % End of DRAxis

		Obj = AxModify( Obj, varargin )
		% AxModify - Modify value according to field name

		Obj = AxPutRaw( Obj, varargin )
		% AxPutRaw - Put raw data into DRAxis object

		Obj = AxPutModel( Obj, nAxCode, hFunc, varargin )
		% AxPutModel - Put modeled data into DRAxis object

		function Obj = AxUpdate( Obj )
		% AxUpdate - Update Axis data and set state ready
		%
		% 	Obj = Obj.AxUpdate()

			disp( ['Update Axis', num2str( Obj.nAxCode ) ] );
			% Do unit conversion
			switch Obj.nAxType
			case 0
				AxType = 'Len';
			case 1
				AxType = 'Rot';
			end

			[ Obj.mUnit, Obj.CMD_Raw ] = Obj.mUnit.DoIDUnitConv( 1, Obj.CMD_Raw, AxType );
			[ Obj.mUnit, Obj.FBK_Raw ] = Obj.mUnit.DoIDUnitConv( 2, Obj.FBK_Raw, AxType );
			Obj.mUnit = Obj.mUnit.IsUnitSync();

			if ~isempty( Obj.CMD_Raw )
				Obj.CMD_Pos = Obj.CMD_Raw - Obj.CrdShift;
			end
			if ~isempty( Obj.FBK_Raw )
				Obj.FBK_Pos = Obj.FBK_Raw - Obj.CrdShift;
			end
			% Modified data according to axis type
			switch AxType
			case 'Rot'
					Obj.CMD_Pos = Obj.mMath.ModToAbsDeg( Obj.CMD_Pos );
					Obj.FBK_Pos = Obj.mMath.ModToAbsDeg( Obj.FBK_Pos );
			otherwise
			end

			% Calculate Vel and Acc
			Obj = Obj.AxGetVel();
			Obj = Obj.AxGetAcc();
			Obj = Obj.AxGetJerk();
		end % End of AxUpdate

		function Obj = AxSetTime( varargin )
		% AxSetTime - Set time space for simulation
		%
		% 	Obj = Obj.AxSetTime( Timebase )
		% 	Obj = Obj.AxSetTime( Timebase, Timeshift )
			Obj = varargin{ 1 };
			Timebase = varargin{ 2 };
			if nargin > 2
				Timeshift = varargin{ 3 };
			else
				Timeshift = 0.0;
			end
			Obj.Time = ( 0 : Timebase : ( Obj.nAxCount - 1 ) * Timebase ) + Timeshift;
			Obj.Time = Obj.Time';
		end % End of AxSetTime

		function Obj = AxSetUnit( Obj, Type, nDim, nPrec )
		% AxSetUnit - Set axis unit mode
		%
		% 	Obj = Obj.AxSetUnit()
			Obj.mUnit = Obj.mUnit.SetUnitMode( Type, nDim, nPrec );
		end

		function Mode = AxGetUnit( Obj )
		% AxGetUnit - Get axis unit mode
		%
		% 	Mode = Obj.AxGetUnit()
			Mode = Obj.mUnit.CurrMode;
		end

		function Obj = AxSetDefaultUnit( Obj, Type, nDim, nPrec )
		% AxSetDefaultUnit
		%
		% Obj = Obj.AxSetDefaultUnit( Type, nDim, nPrec )
			Obj.mUnit = Obj.mUnit.SetDefaultUnitMode( Type, nDim, nPrec );
		end % End of AxSetDefaultUnit

		function Obj = AxGetVel( Obj )
		% AxGetVel - Get axis velocity
		%
		% Obj = Obj.AxGetVel()
			if isempty( Obj.Time )
				disp( 'time space is empty, please use func AxSetTime first' );
			else
				% Process CMD
				if ~isempty( Obj.CMD_Pos )
					Obj.CMD_Vel = [ 0; diff( Obj.CMD_Pos ) ./ diff( Obj.Time ) ];
				end
				% Process FBK
				if ~isempty( Obj.FBK_Pos )
					Obj.FBK_Vel = [ 0; diff( Obj.FBK_Pos ) ./ diff( Obj.Time ) ];
				end
			end
		end % End of AxGetVel

		function Obj = AxGetAcc( Obj )
		% AxGetAcc - Get axis acceleration
		%
		% Obj = Obj.AxGetAcc()
			if isempty( Obj.Time )
				disp( 'time space is empty, please use func AxSetTime first' );
			else
				% Process CMD
				if ~isempty( Obj.CMD_Vel )
					Obj.CMD_Acc = [ 0; diff( Obj.CMD_Vel ) ./ diff( Obj.Time ) ];
				end
				% Process FBK
				if ~isempty( Obj.FBK_Vel )
					Obj.FBK_Acc = [ 0; diff( Obj.FBK_Vel ) ./ diff( Obj.Time ) ];
				end
			end
		end % End of AxGetAcc

		function Obj = AxGetJerk( Obj )
		% AxGetJerk - Get axis Jerk
			if isempty( Obj.Time )
				disp( 'time space is empty, please use func AxSetTime first' );
			else
				% Process CMD
				if ~isempty( Obj.CMD_Acc )
					Obj.CMD_Jerk = [ 0; diff( Obj.CMD_Acc ) ./ diff( Obj.Time ) ];
				end
				% Process FBK
				if ~isempty( Obj.FBK_Acc )
					Obj.FBK_Jerk = [ 0; diff( Obj.FBK_Acc ) ./ diff( Obj.Time ) ];
				end
			end
		end

	end % End of methods
end % End of classdef

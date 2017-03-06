classdef DRAxis
% DRAxis - DataRecorder Axis Store
	properties ( GetAccess = 'public', SetAccess = 'private' )
		% Related to state
		AxState = 'Wait update';
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
		% Unit
		CurrUnitMode = 'BLU';
		% Math Module
		mMath = CZMath;
		mCurv = CZCurve;
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

		function Obj = AxModify( varargin )
		% AxModify - Modify value according to field name
		%
		% 	Obj = Obj.AxModify( 'Field', Value... )
			Obj = varargin{ 1 };
			nLen = ( length( varargin ) - 1 ) / 2.0;
			for i = 1 : nLen
				switch varargin{ i * 2 }
				case 'nAxCode'
					Obj.nAxCode = varargin{ i * 2 + 1 };
				case 'nAxType'
					Obj.nAxType = varargin{ i * 2 + 1 };
				case 'CrdShift'
					Obj.CrdShift = varargin{ i * 2 + 1 };
				case 'DisplayRatio'
					Obj.DisplayRatio = varargin{ i * 2 + 1 };
				otherwise
					disp( 'No match field, or direct set is not allowable' );
				end
			end
		end % End of AxModify

		function Obj = AxPutRaw( varargin )
		% AxPutRaw - Put raw data
		%
		% 	Obj = Obj.AxPutRaw( AxCMD, 'CMD', nAxCode )
		% 	Obj = Obj.AxPutRaw( AxFBK, 'FBK', nAxCode )
		% 	Obj = Obj.AxPutRaw( AxCMD, AxFBK, nAxCode )

			% Initialize
            Obj = varargin{ 1 };
			if ischar( varargin{ 3 } )
				sMethod = varargin{ 3 };
			else
				sMethod = 'Both';
			end
			% Put data
			switch sMethod
			case 'Both'
				Obj.CMD_Raw = varargin{ 2 };
				Obj.FBK_Raw = varargin{ 3 };
				Obj.nAxCount = length( Obj.CMD_Raw );
			otherwise
				switch sMethod
				case 'CMD'
					Obj.CMD_Raw = varargin{ 2 };
					Obj.nAxCount = length( Obj.CMD_Raw );
				case 'FBK'
					Obj.FBK_Raw = varargin{ 3 };
					Obj.nAxCount = length( Obj.FBK_Raw );
				end
			end

			if nargin > 3
				Obj.nAxCode = varargin{ 4 };
			else
				Obj.nAxCode = 1;
			end
		end % End of AxPutRaw

		function Obj = AxPutModel( Obj, varargin )
		% AxPutModel -
		%
		% 	Obj = Obj.AxPutModel( nAxCode, hModel, Ax1, Ax2 ... )
		% 	Input:
		% 		nAxCode:
		% 		hModel: Model handle
		% 		Ax: DRAxis Object that needed
			Obj.nAxCode = varargin{ 1 };
			Obj.hModel = varargin{ 2 };

			% Check number of arguments
			nArg = nargin( Obj.hModel );
			if nargin < ( 2 + nArg )
				disp( 'Not enough input argumnets' );
			else
				str = [ 'varargin{ 3 }.CMD_Raw' ];
				for i = 2 : nArg
					str = [ str, ', varargin{ ', num2str( i + 2 ), ' }.CMD_Raw' ];
				end
				eval( [ 'Obj.CMD_Raw = Obj.hModel( ', str, ' )' ] );
			end
		end

		function Obj = AxUpdate( Obj )
		% AxUpdate - Update Axis data and set state ready
		%
		% 	Obj = AxUpdate( Obj )

			disp( ['Update Axis', num2str( Obj.nAxCode ) ] );
			if ~isempty( Obj.CMD_Raw )
				Obj.CMD_Pos = Obj.CMD_Raw * 1e-3 - Obj.CrdShift;
			end
			if ~isempty( Obj.FBK_Raw )
				Obj.FBK_Pos = Obj.FBK_Raw * 1e-3 - Obj.CrdShift;
			end
			% Modified data according to axis type
			switch Obj.nAxType
			case 1 % Rotation
					Obj.CMD_Pos = Obj.mMath.ModToAbsDeg( Obj.CMD_Pos );
					Obj.FBK_Pos = Obj.mMath.ModToAbsDeg( Obj.FBK_Pos );
			otherwise % Linear
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

classdef DREnv
% DREnv - DataRecorder environemt store
	properties ( GetAccess = 'public', SetAccess = 'private' )
		% Environment
		Name = '';
		% Related to time
		Timebase = 3000 * 1.0e-6;
		Timeline = [];
		TMovIni = -1;
		TMovEnd = -1;
		% Related to unit conversion
		CurrUnitMode = 'BLU';
		NextUnitMode = 'IU';
		ToIU = 1 / 1000;
		% Related to intrinsic axis store
		Ax = DRAxis.empty;
		nAxDetectMov = 1;
		nAxMap = [];
		nAxNum = 0;
		% Related to explicit axis store

	end
	methods
		function Obj = DREnv( varargin )
		% DREnv - Constructor of object DREnv
		%
		% 	Obj = DREnv(  )
            if nargin > 0
                Obj.Timebase = varargin{ 1 } * 1.0e-6;
            end
		end % End of DREnvironment constructor

		function obj = EnvModify( varargin )
		% EnvModify - Modify value according to field name
		%
		% 	Obj = Obj.EnvModify( 'Field', Value... )
			obj = varargin{ 1 };
			nLen = ( length( varargin ) - 1 ) / 2.0;

			for i = 1 : nLen
				switch varargin{ i * 2 }
				case 'Name'
					obj.Name = varargin{ i * 2 + 1 };
				case 'nAxDetectMov'
					obj.nAxDetectMov = varargin{ i * 2 + 1 };
				case 'Timebase'
					obj.Timebase = varargin{ i * 2 + 1 } * 1.0e-6;
				case 'Timeline'
					disp( 'Please use function EnvTimeline() instead' );
				case 'CurrUnitMode'
					disp( 'Please use function EnvSetUnit() instead' );
				case 'NextUnitMode'
					disp( 'Please use function EnvSetUnit() instead' );
				otherwise
					disp( 'No match field, or direct set is not allowable' );
				end
			end
		end % End of EnvModify

		function Obj = EnvReadFile( varargin )
		% EnvReadFile - Read file and store data into DRAxis object
		%
		% 	Obj = Obj.EnvReadFile( sFileName, sMethod )
		% 	Obj = Obj.EnvReadFile( sFileName, nAxMap, sMethod )
		% 	Obj = Obj.EnvReadFile( sFileName, nAxChoose, nAxMap, sMethod )
		% 	Input:
		% 		nAxMap: Mapping file column with AxName
		% 		nAxChoose: Choose only specific cols, size must equal to nAxMap
		% 		sMethod( Optional ):
		% 			'CMD': Each col is considered as an separate CMD.
		% 			'FBK': Each col is considered as an separate FBK.
		% 			'Both': ( default ) Read both CMD and FBK, two cols a set
		%
		% 	Explain:
		% 		Given a DR file 'DRData.txt', col:
		% 		1~2->(XAxis), 3~4->(CAxis), 5~6->(ZAxis), 7~8 and more, then
		% 		DRFileRead( 'DRData.txt',[ 1, 2, 3 ], [ 1, 6, 3 ] );
		% 		which means I only need data from col 1~2, 3~4, 5~6.
		% 		And those col mapping to XAxis: 1, CAxis: 6, ZAxis: 3
		%
		% 		After processing, the function outputs CMD and FBK data
		%		with nAxMap == [ 1, 3, 6 ]

			% Initialize
			narginchk( 2, 5 );
			Obj = varargin{ 1 };

			% Read file get raw data ( Both CMD and FBK )
			DataRaw = load( varargin{ 2 } );

			% Input read file arguments
			if ischar( varargin{ end } )
				sMethod = varargin{ end };
				switch nargin
					case 5
						Obj.nAxMap = varargin{ 4 };
						nAxChoose = varargin{ 3 };
					case 4
						Obj.nAxMap = varargin{ 3 };
						nAxChoose = [];
					case 3
						Obj.nAxMap = [];
						nAxChoose = [];
				end
			else
				sMethod = 'Both';
				switch nargin
					case 4
						Obj.nAxMap = varargin{ 4 };
						nAxChoose = varargin{ 3 };
					case 3
						Obj.nAxMap = varargin{ 3 };
						nAxChoose = [];
					case 2
						Obj.nAxMap = [];
						nAxChoose = [];
				end
			end

			switch sMethod
				case 'Both'
                    nLenOfDataRaw = length( DataRaw( 1, : ) );
					AxCMD = DataRaw( :, 1 : 2 : ( nLenOfDataRaw - 1 ) );
					AxFBK = DataRaw( :, 2 : 2 : nLenOfDataRaw );
					% Trim AxCMD
					if ~isempty( nAxChoose )
						AxCMD = AxCMD( :, nAxChoose );
						AxFBK = AxFBK( :, nAxChoose );
					end
					Obj.nAxNum = length( AxCMD( 1, : ) );
					% Rearrange AxCMD AxFBK
					if ~isempty( Obj.nAxMap )
						[ Obj.nAxMap, nSortedIdx ] = sort( Obj.nAxMap );
						AxCMD = AxCMD( :, nSortedIdx );
						AxFBK = AxFBK( :, nSortedIdx );
					else
						Obj.nAxMap = 1 : Obj.nAxNum;
					end
					% Put data into DRAxis
					for i = 1 : Obj.nAxNum
						Obj.Ax( i ) = DRAxis( AxCMD( :, i ), AxFBK( :, i ), Obj.nAxMap( i ) );
					end

				otherwise
					AxCMD = DataRaw( :, : );
					% Trim AxCMD
					if ~isempty( nAxChoose )
						AxCMD = AxCMD( :, nAxChoose );
					end
					Obj.nAxNum = length( AxCMD( 1, : ) );
					% Rearrange AxCMD
					if ~isempty( Obj.nAxMap )
						[ Obj.nAxMap, nSortedIdx ] = sort( Obj.nAxMap );
						AxCMD = AxCMD( :, nSortedIdx );
					else
						Obj.nAxMap = 1 : Obj.nAxNum;
					end
					% Put data into DRAxis
					for i = 1 : Obj.nAxNum
                        disp( [ 'Put Axis', num2str( Obj.nAxMap( i ) ), sMethod ] );
						Obj.Ax( i ) = DRAxis( AxCMD( :, i ), sMethod, Obj.nAxMap( i ) );
					end
			end
		end % End of EnvReadFile

		function Obj = ReadDR( Obj )
		% ReadDR -  Read Traj from DataRecorder
		%
		% 	Obj = Obj.ReadDR()
		end % End of ReadDR

		function Obj = ReadNC( Obj, sFileName, sFormat, nAxChoose, nAxMap )
		% ReadNC - Read Traj from NC
		%
		% 	Obj = Obj.ReadNC( sFileName, sFormat )
		% 	Obj = Obj.ReadNC( sFileName, sFormat, nAxMap )
		% 	Obj = Obj.ReadNC( sFileName, sFormat, nAxChoose, nAxMap )
		% 	Input:
		% 		For example, X10. Z10. F100.
		% 		Obj = Obj.ReadNC( 'sPath', 'X%f Z%f F%f' )

			% Initialize
			narginchk( 3, 5 );
			fp = fopen( sFileName, 'r' );

			% Create format
			DataRaw = textscan( fp, sFormat );
			switch nargin
			case 5
				Obj.nAxMap = nAxMap;
			case 4
				Obj.nAxMap = nAxMap;
				nAxChoose = [];
			case 3
				Obj.nAxMap = [];
				nAxChoose = [];
			end

			% Close file
			fclose( fp );
		end % End of ReadNC

		function Obj = EnvSetAxType( Obj, nAxType )
		% EnvSetAxType - Set axis type
			for i = 1 : Obj.nAxNum
				Obj.Ax( i ) = Obj.Ax( i ).AxModify( 'nAxType', nAxType( i ) );
			end
		end

		function Obj = EnvSetAxShift( Obj, AxShift )
		% EnvSetAxShift - Set axis coordinate shift
			for i = 1 : Obj.nAxNum
				Obj.Ax( i ) = Obj.Ax( i ).AxModify( 'CrdShift', AxShift( i ) );
			end
		end

		function Obj = EnvSetTime( varargin )
		% EnvTimeline - Set timebase and update DRAxis.time
		%
		% 	Obj = Obj.EnvSetTime()
		% 	Obj = Obj.EnvSetTime( timebase )
			Obj = varargin{ 1 };
			if nargin > 1
				Obj.Timebase = varargin{ 2 } * 1.0e-6;
			end

			for i = 1 : Obj.nAxNum
				Obj.Ax( i ) = Obj.Ax( i ).AxSetTime( Obj.Timebase );
			end
		end % End of EnvSetTime

		function Obj = EnvAxUpdate( Obj )
		% EnvAxUpdate - Update all DRAxis that link to this environment
		%
		% 	Obj = Obj.EnvAxUpdate()
			Obj = Obj.EnvSetTime();
			for i = 1 : Obj.nAxNum
				Obj.Ax( i ) = Obj.Ax( i ).AxUpdate();
			end
		end % End of EnvAx

		function Obj = EnvSetUnit( varargin )
		% EnvSetUnit - Set Unit Conversion Coefficients
		%
		% 	Obj = Obj.EnvSetUnit( 'NextUnitMod' )
			Obj = varargin{ 1 };
			switch varargin{ 2 }
			case 'BLU'
			case 'IU'
			case 'CNC'
			otherwise
				disp( 'No match Unit Mode' );
			end
		end % End of EnvSetUnit

	end % End of Methods
end % End of classdef

classdef DRAnalyzer
% DRAnalyzer - DataRecorder analyzer
	properties ( GetAccess = 'public', SetAccess = 'private' )
		mMath = CMath();
	end
	methods
		function Obj = DRAnalyzer()
		% DRAnalyzer - Constructor of DRAnalyzer object
		end % End of DRAnalyzer Constructor

		varargout = AnlysGridGen( Obj, GridSize, varargin )
		% AnlysGridGen - Analyze raw data, then Generate grid

		varargout = AnlysAdjPath( Obj, hFunc, varargin )
		% AnlysAdjPath - Analyze on adjacent path

		varargout = AnlysNoisePt( Obj, sMethod, varargin )
		% AnlysNoisePt - Analyze noise point

	end % End of methods
end % End of classdef

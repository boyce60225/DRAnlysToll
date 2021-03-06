classdef CMath
	properties ( GetAccess = 'public', SetAccess = 'private' )
		mCurv = CCurve;
	end % End of properties
	properties ( Constant )
		zToDeg = 180.0 / pi;
		zToRad = pi / 180.0;
		zToInch = 1.0 / 25.4;
		zToMM = 25.4;
	end % End of properties
	methods
		function Obj = CMath()
		% CMath - Universal math tool object
		end % End of CMath Constructor

		DegRaw = ModToAbsDeg( Obj, DegRaw )
		% ModToAbsDeg - Convert raw deg ( modulo 360 ) to contiuous deg

		DegRaw = AbsToModDeg( Obj, DegRaw )
		% AbsToModDeg - Convert raw deg to modulo 360 degree

		Deg_Diff = GetMinDegDiff( Obj, Deg_In1, Deg_In2 )

		vHeight = GetTriHeight( Obj, v1, v2 )
		% GetTriHeight - Compute height of triangle composed of vector v1, v2

		AngleSpan = GetCornerDeg( Obj, v1, v2 )
		% GetCornerDeg - Compute corner angle of consecutive vector ( v1 to v2 )

		function [] = MovingAverage( Obj, nQueSize )
		% MovingAverage -
		end % End of MovingAverage

		varargout = TrajSmooth( Obj, sMethod, varargin )
		% TrajSmooth - Smooth trajectory based on sMethod

	end % End of methods
end % End of classdef

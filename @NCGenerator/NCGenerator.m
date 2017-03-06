classdef NCGenerator
	properties( GetAccess = 'public', SetAccess = 'private' )
		ZMath = CZMath.empty();
		Env = DREnv.empty();
	end
	methods
		function Obj = NCGenerator(  )
		end % End of NCGenerator Constructor

		function [ out ] = g( in )
		% function: Short description
		%
		% Extended description

		end  % End of

		function [  ] = NCGen( Obj, sFileName )
		% NCGen - Generate NC file
		end
	end
end % End of classdef

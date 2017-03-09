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

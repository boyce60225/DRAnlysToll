function [ X, Y ] = Bezier( varargin )
% Bezier - Output bezier curve
%
% 	[ X, Y ] = Obj.Bezier( CtrlX, CtrlY, nCount, w )
% 	Input:
% 		CtrlX: First dimension control points
% 		CtrlY: Second dimension control points
% 		nCount: Number of points in bezier curve
%		w: Weighting in rational bezier curve
%

	% Initialize
	Obj = varargin{ 1 };
	CtrlX = varargin{ 2 };
	CtrlY = varargin{ 3 };
	nCount = varargin{ 4 };

	%number of arguments in
	if nargin < 5
		% common Bezier not rational
		w = ones( length( CtrlX ), 1 );
	else
		w = varargin{ 5 };
	end

	t = linspace( 0.0, 1.0, nCount );
	BernsteinPoly = zeros( length( CtrlX ), nCount );
	xx = 0; yy = 0;

	%Bernstein polynomials
	for k = 0 : ( length( CtrlX ) - 1 )
		BernsteinPoly( k + 1, : ) = ...
			nchoosek( ( length( CtrlX ) - 1 ), k ) * w( k + 1 ) * ...
			t .^ k .* ...
			( 1 - t ) .^ ( ( length( CtrlX ) - 1 ) - k );
		xx = xx + BernsteinPoly( k + 1, : ) * CtrlX( k + 1 );
		yy = yy + BernsteinPoly( k + 1, : ) * CtrlY( k + 1 );
	end

	den = sum( BernsteinPoly );
	xx = xx ./ den;
	yy = yy ./ den;
	X = xx;
	Y = yy;
end

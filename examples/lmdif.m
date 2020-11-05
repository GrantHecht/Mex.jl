% Levenberg-Marquardt solver with finite differencing for the Jacobian
function x = lmdif(f, x0)

% first time through, load the julia function
persistent loaded;
if isempty(loaded)
  jl_file = fullfile(fileparts(mfilename('fullpath')), 'lmdif.jl');
  jl.include(jl_file);
  loaded = true;
end

sln = jl.callkw('lmdif', 2, f, x0, 'show_trace', true);
% or
%sln = jl.mex('lmdif', 2, f, x0, true);

if ~(sln.x_converged || sln.f_converged || sln.g_converged)
  throw('lmdif failed to converge');
end

x = sln.minimizer;

end

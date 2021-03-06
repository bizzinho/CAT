function solve(O)
%% CAT.solve
% solve is a method of the CAT class. It integrates the problem according to
% the settings of the CAT object and fills in the calc-properties of the
% same object. The method does not accept any additional inputs, all options 
% should therefore be set via the property fields of the object.
% Solve is structured into two nested parts: An upper layer that handles
% discontinuities in the supplied AS or T profiles and a lower layer (the
% solvers).

% Copyright 2015-2016 David Ochsenbein
% Copyright 2012-2014 David Ochsenbein, Martin Iggland
% 
% This file is part of CAT.
% 
% CAT is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation version 3 of the License.
% 
% CAT is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.


%% Solve

for ii = 1:length(O)

    % A small number of properties are allowed to be empty when filling out
    % a CAT object, but you should set them to default (do nothing) values
    % when starting the solver
    O(ii).setDefaults('emptyonly');
    
    
    O(ii).calc_dist = Distribution;
    if ~isempty(O(ii).init_seed) && O(ii).init_seed > 0
        O(ii).init_dist.F = O(ii).init_dist.F*O(ii).init_seed/(moments(O(ii).init_dist,3)*O(ii).kv*O(ii).rhoc*O(ii).init_massmedium);
    end


    % Save for later
    sol_time = O(ii).sol_time;
    calc_time = [];
    calc_dist = Distribution;
    calc_conc = [];

    effectiveNodes = sort(unique([sol_time(1) O(ii).tNodes sol_time(end)])); 

    for i = 2:length(effectiveNodes) % make sure you hit the different nodes of non-smooth profiles

        % Cut out the piece we want to look at currently
        O(ii).sol_time = [effectiveNodes(i-1);sol_time(sol_time>effectiveNodes(i-1) & sol_time<effectiveNodes(i));effectiveNodes(i)];

        % Solve for the current piece
        try
            % Simply run the method corresponding to the chosen solution method
            % prefixed with solver_
            [mbflag] = O(ii).(['solver_' O(ii).sol_method]);
        catch ME
            error('solve:tryconsttemp:PBESolverfail',...
            'Solver failed to integrate your problem. Message: %s',ME.message)

        end

        % Save the solution for the current piece
        calc_time(end+1:end+length(O(ii).calc_time)) = O(ii).calc_time;
        calc_dist(end+1:end+length(O(ii).calc_dist)) = O(ii).calc_dist;
        calc_conc(end+1:end+length(O(ii).calc_conc)) = O(ii).calc_conc; 

        % Set new initial distribution and initial concentration
        O(ii).init_dist = O(ii).calc_dist(end);
        O(ii).init_conc = O(ii).calc_conc(end);

        if mbflag 
            mb = massbal(O(ii));
            warning('CAT:solve:massbalanceerrortoolarge',...
                'Your mass balance error is unusually large (%4.2f%%). Check validity of equations, size of the grid and consider increasing the number of bins; simulation aborted.',mb(end));
            break
        end
    end % for

    % Put temporary solution into the right place
    O(ii).calc_time = calc_time;
    O(ii).calc_dist = calc_dist(2:end);
    O(ii).calc_conc = calc_conc;
    % Reset times and initial distribution, concentration
    O(ii).sol_time = sol_time;
    O(ii).init_dist = calc_dist(2);
    O(ii).init_conc = calc_conc(1);



    O(ii).init_conc = O(ii).calc_conc(1);
    O(ii).init_dist = O(ii).calc_dist(1);

    if length(O(ii).sol_time)>2
        [~,I] = intersect(O(ii).calc_time,O(ii).sol_time);
        O(ii).calc_time = O(ii).calc_time(I);
        O(ii).calc_dist = O(ii).calc_dist(I);
        O(ii).calc_conc = O(ii).calc_conc(I);
    end
    
    % Let first dimension always be time
    O(ii).calc_time = O(ii).calc_time(:);
    O(ii).calc_dist = O(ii).calc_dist(:);
    O(ii).calc_conc = O(ii).calc_conc(:);
    
end
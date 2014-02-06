%% Method editDist

function editDist(O,~,~,classvarname,displayfield)

% Open new GUI window which lets user define the distribution
% by choosing a grid and

% Create the figure handle
Dgui.fighandle = figure(...
    'MenuBar','none',...
    'Name','Edit initial distribution',...
    'NumberTitle','off',...
    'Position',[200 200 500 445],...
    'Resize','off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grid
%

% Panel
Dgui.grid.panel = uipanel('Parent',Dgui.fighandle,...
    'Title','Grid',...
    'Units','pixels',...
    'Position',[20 355 460 70]);

% Button group for the radio buttons
Dgui.grid.spacingtype = uibuttongroup('Parent',Dgui.grid.panel,...
    'Title','',...
    'Units','pixels',...
    'BorderType','none',...
    'Position',[10 10 100 40]);

% Radio button 'linear'
Dgui.grid.spacingtype_lin = uicontrol(Dgui.grid.spacingtype,...
    'Style','radiobutton',...
    'String','Linear',...
    'Position',[0 20 100 20]);

% Radio button 'logarithmic'
Dgui.grid.spacingtype_lin = uicontrol(Dgui.grid.spacingtype,...
    'Style','radiobutton',...
    'String','Logarithmic',...
    'Position',[0 0 100 20]);

% Opening bracket
Dgui.grid.bracket_left = uicontrol(Dgui.grid.panel,...
    'Style','text',...
    'String','[',...
    'Units','pixels',...
    'FontSize',20,...
    'HorizontalAlignment','right',...
    'Position',[110 10 30 30]);

% Min field
Dgui.grid.min_text = uicontrol(Dgui.grid.panel,...
    'Style','text',...
    'String','Min.',...
    'Units','pixels',...
    'Position',[140 35 70 20]);

Dgui.grid.min = uicontrol(Dgui.grid.panel,...
    'Style','edit',...
    'String','0',...
    'TooltipString','Starting point of calculation grid',...
    'Units','pixels',...
    'Position',[140 10 70 30]);

% Spacing field
Dgui.grid.max_text = uicontrol(Dgui.grid.panel,...
    'Style','text',...
    'String','Spacing',...
    'Units','pixels',...
    'Position',[215 35 70 20]);

Dgui.grid.min = uicontrol(Dgui.grid.panel,...
    'Style','edit',...
    'String','0.1',...
    'TooltipString','Spacing of grid points',...
    'Units','pixels',...
    'Position',[215 10 70 30]);

% Max field
Dgui.grid.max_text = uicontrol(Dgui.grid.panel,...
    'Style','text',...
    'String','Max.',...
    'Units','pixels',...
    'Position',[290 35 70 20]);

Dgui.grid.max = uicontrol(Dgui.grid.panel,...
    'Style','edit',...
    'String','2',...
    'TooltipString','End point of calculation grid',...
    'Units','pixels',...
    'Position',[290 10 70 30]);

% Closing bracket
Dgui.grid.bracket_right = uicontrol(Dgui.grid.panel,...
    'Style','text',...
    'String',']',...
    'Units','pixels',...
    'FontSize',20,...
    'HorizontalAlignment','left',...
    'Position',[360 10 30 30]);

% Number of gridpoints field
Dgui.grid.numpoints_text = uicontrol(Dgui.grid.panel,...
    'Style','text',...
    'String','Gridpoints',...
    'Units','pixels',...
    'Position',[380 35 70 20]);

Dgui.grid.numpoints = uicontrol(Dgui.grid.panel,...
    'Style','edit',...
    'String','21',...
    'TooltipString','Number of grid points',...
    'Units','pixels',...
    'Position',[380 10 70 30]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Population density
%

% Panel
Dgui.density.panel = uipanel('Parent',Dgui.fighandle,...
    'Title','Population density',...
    'Units','pixels',...
    'Position',[20 275 460 70]);

% Function field
Dgui.density.function_text = uicontrol(Dgui.density.panel,...
    'Style','text',...
    'String','Function',...
    'Units','pixels',...
    'Position',[40 35 180 20]);
% @(x) label
Dgui.density.function_text2 = uicontrol(Dgui.density.panel,...
    'Style','text',...
    'String','@(x)',...
    'Units','pixels',...
    'Position',[10 10 30 20]);

Dgui.density.function = uicontrol(Dgui.density.panel,...
    'Style','edit',...
    'String','normalpdf(x,1,0.1,20)',...
    'TooltipString','Function defining population density',...
    'Units','pixels',...
    'Position',[40 10 180 30]);

% Values field
% Text
Dgui.density.values_text = uicontrol(Dgui.density.panel,...
    'Style','text',...
    'String','Values',...
    'Units','pixels',...
    'Position',[230 35 180 20]);
% Left bracket
Dgui.density.values_bracketleft = uicontrol(Dgui.density.panel,...
    'Style','text',...
    'String','[',...
    'Units','pixels',...
    'FontSize',20,...
    'HorizontalAlignment','right',...
    'Position',[230 10 5 30]);
% Input box
Dgui.density.values = uicontrol(Dgui.density.panel,...
    'Style','edit',...
    'String','',...
    'TooltipString','Values defining population density (separate with space)',...
    'Units','pixels',...
    'Position',[235 10 155 30]);
% Right bracket
Dgui.density.values_bracketright = uicontrol(Dgui.density.panel,...
    'Style','text',...
    'String',']',...
    'Units','pixels',...
    'FontSize',20,...
    'HorizontalAlignment','left',...
    'Position',[390 10 10 30]);
% Browse button
Dgui.density.values_browse = uicontrol(Dgui.density.panel,...
    'Style','pushbutton',...
    'String','Browse',...
    'Value',0,...
    'Callback',@(hObject,eventdata)O.browseVars(hObject,eventdata,[],Dgui.density.values),...
    'Position',[405 10 50 30]...
    );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Preview
%

% Panel
Dgui.preview.panel = uipanel('Parent',Dgui.fighandle,...
    'Title','Preview',...
    'Units','pixels',...
    'Position',[20 45 460 220]);

% Update button
Dgui.preview.update = uicontrol(Dgui.preview.panel,...
    'Style','pushbutton',...
    'String','Update',...
    'Value',0,...
    'Callback','',...
    'Position',[405 185 50 20]...
    );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OK, Reset, Cancel buttons
%

% OK Button
Dgui.buttons.ok = uicontrol(Dgui.fighandle,...
    'Style','pushbutton',...
    'String','OK',...
    'Value',0,...
    'Callback','',...
    'Position',[70 10 100 30]...
    );

% Reset Button
Dgui.buttons.ok = uicontrol(Dgui.fighandle,...
    'Style','pushbutton',...
    'String','Reset',...
    'Value',0,...
    'Callback','',...
    'Position',[200 10 100 30]...
    );

% Cancel Button
Dgui.buttons.ok = uicontrol(Dgui.fighandle,...
    'Style','pushbutton',...
    'String','Cancel',...
    'Value',0,...
    'Callback',@cancelDgui,...
    'Position',[330 10 100 30]...
    );

    function cancelDgui(O,~)
        
        % Close the editing GUI without doing anything
        close(Dgui.fighandle)
        
        clear Dgui
        
    end % function cancelDgui

end % function editDist
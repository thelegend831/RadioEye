classdef RadioEye < handle
    %% Layout parameters
    properties (Constant)
        LayoutW = 1200;
        LayoutH = 700;
    end
    
    methods (Static)
        function pixelPos = ratio2pixelUnits(W,H,ratioPos)
            pixelPos = ratioPos.*[W H W H];
        end
        function ratioPos = pixel2ratioUnits(W,H,pixelPos)
            ratioPos = pixelPos./[W H W H];
        end
    end
    %% Interface objects
    properties (Access = public)
        Interface % main figure
        Menu
        ModeToggle
        Viewer
        Legends
        EmOperationPanel
        AbOperationPanel
        ClOperationPanel
    end
    %% Data objects
    properties (SetObservable, AbortSet)
        Mode = 'Emulate';
        EmLabelSystemName = 'Coarse9Label';
        AbLabelSystemName = 'Coarse9Label';
        ClLabelSystemName = 'Coarse9Label';
        Emulate
        Ablate
        Calibrate
    end
    %% Callback methods
    methods (Access = public)
    end
    %% App methods
    methods (Access = public)
        % Constructor
        function app = RadioEye()
            init(app);
        end
        % Destructor
        function delete(app,src,edata)
            delete(app.Interface);
        end
        % Initial Layout
        function init(app)
            app.Interface = figure('Position',[100 100 app.LayoutW app.LayoutH],...
                'Name','RadioEye','NumberTitle','off','MenuBar','none','ToolBar','none',...
                'Resize','off',...
                'CloseRequestFcn',@app.delete);
            app.Menu = REMenu(app,[60 660 400 20],app.Mode);
            app.ModeToggle = REModeToggle(app,[550 630 100 60],app.Mode);
            app.Viewer = REViewer(app,[60 18 500 602]);
            app.Legends = RELegendArray(app,[710 220 200+2*(25+5) 300]);
            app.EmOperationPanel = REEmOperationPanel(app,[610 60 300+100 140]);
            app.EmOperationPanel.turnOnPanel();
            app.AbOperationPanel = REAbOperationPanel(app,[610 60 300+100 140]);
            app.AbOperationPanel.turnOffPanel();
            app.Ablate = REAblate(app); app.Viewer.turnOnEmView();
        end
    end
end
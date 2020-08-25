classdef REViewer < handle
    %% Parameters
    properties
        Parent
        Position
    end
    %% Components
    properties
        axEmView % View axes
        axEmLblbar % Label bar
        imEmLblimg % Label image
        lnEmPlotRL
        lnEmPlotPA
        
        axAbView % View axes
        axAbLblbar % Label bar
        imAbLblimg
        lnAbPlotRL
        lnAbPlotPA
        
        axClView % View axes
        axClLblbar % Label bar
        imClLblimg
        lnClPlotRL
        lnClPlotPA
        
        sldCommonSlider
    end
    %% Status Container
    properties
        EmSliderMax = 30;
        EmSliderValue = 15;
        
        AbSliderMax = 100;
        AbSliderValue = 50;
        
        ClSliderMax = 200;
        ClSliderValue = 100;
    end
    
    %% Callback methods
    methods
        function modeDisplayUpdate(obj,src,edata)
            switch edata.AffectedObject.Mode
                case 'Emulate'
                    obj.turnOnEmView();
                case 'Ablate'
                    obj.turnOnAbView();
                case 'Calibrate'
                    obj.turnOnClView();
            end
        end
        
        function turnOnEmView(obj)
            set(obj.sldCommonSlider,'Visible',0);
            obj.axAbView.Visible = 'off';
            obj.axAbLblbar.Visible = 'off';
            obj.imAbLblimg.Visible = 'off';
            obj.lnAbPlotRL.Visible = 'off';
            obj.lnAbPlotPA.Visible = 'off';
            
            obj.axClView.Visible = 'off';
            obj.axClLblbar.Visible = 'off';
            obj.imClLblimg.Visible = 'off';
            obj.lnClPlotRL.Visible = 'off';
            obj.lnClPlotPA.Visible = 'off';
            
            if(isa(obj.Parent.Emulate,'REEmulate'))
                obj.axEmView.Visible = 'on';
                obj.axEmLblbar.Visible = 'on';
                obj.imEmLblimg.Visible = 'on';
                obj.lnEmPlotRL.Visible = 'on';
                obj.lnEmPlotPA.Visible = 'on';
                obj.setToEmSlider();
                set(obj.sldCommonSlider,'Visible',1);
            end
        end
        
        function turnOnAbView(obj)
            set(obj.sldCommonSlider,'Visible',0);
            obj.axEmView.Visible = 'off';
            obj.axEmLblbar.Visible = 'off';
            obj.imEmLblimg.Visible = 'off';
            obj.lnEmPlotRL.Visible = 'off';
            obj.lnEmPlotPA.Visible = 'off';
            
            obj.axClView.Visible = 'off';
            obj.axClLblbar.Visible = 'off';
            obj.imClLblimg.Visible = 'off';
            obj.lnClPlotRL.Visible = 'off';
            obj.lnClPlotPA.Visible = 'off';
            
            if(isa(obj.Parent.Ablate,'REAblate'))
                obj.axAbView.Visible = 'on';
                obj.axAbLblbar.Visible = 'on';
                obj.imAbLblimg.Visible = 'on';
                obj.lnAbPlotRL.Visible = 'on';
                obj.lnAbPlotPA.Visible = 'on';
                obj.setToAbSlider();
                set(obj.sldCommonSlider,'Visible',1);
            end
        end
        
        function turnOnClView(obj)
            set(obj.sldCommonSlider,'Visible',0);
            obj.axEmView.Visible = 'off';
            obj.axEmLblbar.Visible = 'off';
            obj.imEmLblimg.Visible = 'off';
            obj.lnEmPlotRL.Visible = 'off';
            obj.lnEmPlotPA.Visible = 'off';
            
            obj.axAbView.Visible = 'off';
            obj.axAbLblbar.Visible = 'off';
            obj.imAbLblimg.Visible = 'off';
            obj.lnAbPlotRL.Visible = 'off';
            obj.lnAbPlotPA.Visible = 'off';
            
            if(isa(obj.Parent.Calibrate,'RECalibrate'))
                obj.axClView.Visible = 'on';
                obj.axClLblbar.Visible = 'on';
                obj.imClLblimg.Visible = 'on';
                obj.lnClPlotRL.Visible = 'on';
                obj.lnClPlotPA.Visible = 'on';
                obj.setToClSlider();
                set(obj.sldCommonSlider,'Visible',1);
            end
        end
        
        function setToEmSlider(obj)
            set(obj.sldCommonSlider,'Minimum',0,'Maximum',obj.EmSliderMax,...
                'MajorTickSpacing',ceil(obj.EmSliderMax/35)*5);
            % Note set min and max before setting value!
            set(obj.sldCommonSlider,'Value',obj.EmSliderValue);
        end
        
        function setToAbSlider(obj)
            set(obj.sldCommonSlider,'Minimum',0,'Maximum',obj.AbSliderMax,...
                'MajorTickSpacing',ceil(obj.AbSliderMax/35)*5);
            % Note set min and max before setting value!
            set(obj.sldCommonSlider,'Value',obj.AbSliderValue);
        end
        
        function setToClSlider(obj)
            set(obj.sldCommonSlider,'Minimum',0,'Maximum',obj.ClSliderMax,...
                'MajorTickSpacing',ceil(obj.ClSliderMax/35)*5);
            % Note set min and max before setting value!
            set(obj.sldCommonSlider,'Value',obj.ClSliderValue);
        end
        
        function move_sldCommonSlider(obj,src,edata)
            switch obj.Parent.Mode
                case 'Emulate'
                    obj.EmSliderValue = int32(get(src,'Value'));
                case 'Ablate'
                    obj.AbSliderValue = int32(get(src,'Value'));
                case 'Calibrate'
                    obj.ClSliderValue = int32(get(src,'Value'));
            end
        end
        
        function show_EmComponents(obj)
            obj.axEmView.Visible = 'on';
            obj.axEmLblbar.Visible = 'on';
            
        end
        function show_AbComponents(obj)
            obj.axAbView.Visible = 'on';
            obj.axAbLblbar.Visible = 'on'; 
        end
        function show_ClComponents(obj)
            obj.axClView.Visible = 'on';
            obj.axClLblbar.Visible = 'on';
            
        end
        function hide_EmComponents(obj)
            obj.axEmView.Visible = 'off';
            obj.axEmLblbar.Visible = 'off';
            
        end
        function hide_AbComponents(obj)
            obj.axAbView.Visible = 'off';
            obj.axAbLblbar.Visible = 'off';
            
        end
        function hide_ClComponents(obj)
            obj.axClView.Visible = 'off';
            obj.axClLblbar.Visible = 'off';
        end
        
        function adjustEmLblBarSize(obj)
            x= obj.Position(1); y = obj.Position(2); W = obj.Position(3); H = obj.Position(4);
            marginW = W*(1.62/30)*(1/2);
            innerW = W-marginW*2;
            diffW = (0.0/obj.EmSliderMax)*innerW;
            pos_lblBar = [x+diffW+marginW y+H*45/608,...
                innerW H*15/608];
            pos_lblBar = RadioEye.pixel2ratioUnits(obj.Parent.LayoutW,obj.Parent.LayoutH,pos_lblBar);
            set(obj.axEmLblbar,'Position',pos_lblBar);
        end
        function adjustAbLblBarSize(obj)
            x= obj.Position(1); y = obj.Position(2); W = obj.Position(3); H = obj.Position(4);
            marginW = W*(1.62/30)*(1/2);
            innerW = W-marginW*2;
            diffW = (0.0/obj.AbSliderMax)*innerW;
            pos_lblBar = [x+diffW+marginW y+H*45/608,...
                innerW H*15/608];
            pos_lblBar = RadioEye.pixel2ratioUnits(obj.Parent.LayoutW,obj.Parent.LayoutH,pos_lblBar);
            set(obj.axAbLblbar,'Position',pos_lblBar);
        end
        
        function EmulateLoaded(obj,scr,edata)
            h_Emulate = edata.AffectedObject.Emulate;
            % Initialize the slider
            obj.EmSliderMax = h_Emulate.numAcqFrames;
            obj.EmSliderValue = h_Emulate.currFrame-1;
            obj.adjustEmLblBarSize();
            
            % Initialize the label bar
            lblBarColormap = reshape([h_Emulate.LabelSystem.Color],3,[]).';
            obj.imEmLblimg = imagesc(obj.axEmLblbar,h_Emulate.Label(1:h_Emulate.numAcqFrames));
            colormap(obj.axEmLblbar,lblBarColormap);
            obj.axEmLblbar.CLim = [0 length(h_Emulate.LabelSystem)];
            set(obj.axEmLblbar,'YTick',[]);
            
            obj.turnOnEmView();
            
            addlistener(h_Emulate,'numAcqFrames','PostSet',@obj.EmulateUpdated);
            addlistener(h_Emulate,'secPerFrame','PostSet',@obj.EmulateUpdated);
            addlistener(h_Emulate,'currFrame','PostSet',@obj.EmulateUpdated);
        end
        function EmulateUpdated(obj,src,edata)
            h_Emulate = edata.AffectedObject;
            switch src.Name
                case 'numAcqFrames'
                    obj.EmSliderMax = h_Emulate.numAcqFrames;
                    obj.setToEmSlider();
                    obj.adjustEmLblBarSize();
                    % re-draw label image
                    obj.imEmLblimg.delete();
                    obj.imEmLblimg = imagesc(obj.axEmLblbar,h_Emulate.Label(1:h_Emulate.numAcqFrames));
                    lblBarColormap = reshape([h_Emulate.LabelSystem.Color],3,[]).';
                    colormap(obj.axEmLblbar,lblBarColormap);
                    obj.axEmLblbar.CLim = [0 length(h_Emulate.LabelSystem)];
                    set(obj.axEmLblbar,'YTick',[]);
                case 'secPerFrame'
                case 'currFrame'
                    displayFrame = h_Emulate.currFrame-1;
                    
                    obj.EmSliderValue = displayFrame;
                    obj.setToEmSlider();
                    
                    set(obj.imEmLblimg,'CData',h_Emulate.Label(1:h_Emulate.numAcqFrames));
                    set(obj.axEmLblbar,'YTick',[]);
                    
                    axes(obj.axEmView);
                    yyaxis left;
                    obj.lnEmPlotRL = plot(obj.axEmView,h_Emulate.acqFreq,h_Emulate.RL(:,displayFrame),'b-'); axis([-inf inf -90 10]);
                    yyaxis right;
                    obj.lnEmPlotPA = plot(obj.axEmView,h_Emulate.acqFreq,h_Emulate.PA(:,displayFrame),'r--'); axis([-inf inf -200 200]);
            end
        end
        
        function AblateLoaded(obj,scr,edata)
            obj.lnAbPlotRL.XData = []; obj.lnAbPlotRL.YData = [];
            obj.lnAbPlotPA.XData = []; obj.lnAbPlotPA.YData = [];
            
            h_Ablate = edata.AffectedObject.Ablate;
            % Initialize the slider
            obj.AbSliderMax = h_Ablate.numAcqFrames;
            obj.AbSliderValue = h_Ablate.currFrame-1;
            obj.adjustAbLblBarSize();
            
            % Initialize the label bar
            lblBarColormap = reshape([h_Ablate.LabelSystem.Color],3,[]).';
            obj.imAbLblimg = imagesc(obj.axAbLblbar,h_Ablate.Label(1:h_Ablate.numAcqFrames));
            colormap(obj.axAbLblbar,lblBarColormap);
            obj.axAbLblbar.CLim = [0 length(h_Ablate.LabelSystem)];
            set(obj.axAbLblbar,'YTick',[]);
            
            obj.turnOnAbView();
            
            addlistener(h_Ablate,'numAcqFrames','PostSet',@obj.AblateUpdated);
            addlistener(h_Ablate,'secPerFrame','PostSet',@obj.AblateUpdated);
            addlistener(h_Ablate,'currFrame','PostSet',@obj.AblateUpdated);
        end
        function AblateUpdated(obj,src,edata)
            h_Ablate = edata.AffectedObject;
            switch src.Name
                case 'numAcqFrames'
                    obj.AbSliderMax = h_Ablate.numAcqFrames;
                    obj.setToAbSlider();
                    obj.adjustAbLblBarSize();
                    % re-draw label image
                    obj.imAbLblimg.delete();
                    obj.imAbLblimg = imagesc(obj.axAbLblbar,h_Ablate.Label(1:h_Ablate.numAcqFrames));
                    lblBarColormap = reshape([h_Ablate.LabelSystem.Color],3,[]).';
                    colormap(obj.axAbLblbar,lblBarColormap);
                    obj.axAbLblbar.CLim = [0 length(h_Ablate.LabelSystem)];
                    set(obj.axAbLblbar,'YTick',[]);
                case 'secPerFrame'
                case 'currFrame'
                    displayFrame = h_Ablate.currFrame-1;
                    
                    obj.AbSliderValue = displayFrame;
                    obj.setToAbSlider();
                    
                    set(obj.imAbLblimg,'CData',h_Ablate.Label(1:h_Ablate.numAcqFrames));
                    set(obj.axAbLblbar,'YTick',[]);
                    
                    axes(obj.axAbView);
                    yyaxis left;
                    obj.lnAbPlotRL = plot(obj.axAbView,h_Ablate.acqFreq,h_Ablate.RL(:,displayFrame),'b-'); axis([-inf inf -90 10]);
                    yyaxis right;
                    obj.lnAbPlotPA = plot(obj.axAbView,h_Ablate.acqFreq,h_Ablate.PA(:,displayFrame),'r--'); axis([-inf inf -200 200]);
            end
        end
        
    end
    %% Obj methods
    methods
        function obj = REViewer(Parent,Position)
            obj.Parent = Parent;
            obj.Position = Position;
            x = Position(1); y = Position(2); W = Position(3); H = Position(4);
            LayoutW = Parent.LayoutW; LayoutH = Parent.LayoutH;
            
            % initial positions and values
            % label bars position is subject to frame number update
            pos_ax = [x y+H-W W W];
            pos_ax = RadioEye.pixel2ratioUnits(LayoutW,LayoutH,pos_ax);
            pos_slider = [x y W H*45/608];
            pos_labelbar = [x y+H*45/608 W H*15/608];
            pos_labelbar = RadioEye.pixel2ratioUnits(LayoutW,LayoutH,pos_labelbar);
            
            % Views
            obj.axEmView = axes(Parent.Interface,'Position',pos_ax,...
                'Visible','off');
            axes(obj.axEmView);
            yyaxis left; axis([-inf inf -90 10]);
            yyaxis right; axis([-inf inf -200 200]);
            
            obj.axAbView = axes(Parent.Interface,'Position',pos_ax,...
                'Visible','off');
            axes(obj.axAbView);
            yyaxis left; axis([-inf inf -90 10]);
            yyaxis right; axis([-inf inf -200 200]);
            
            obj.axClView = axes(Parent.Interface,'Position',pos_ax,...
                'Visible','off');
            axes(obj.axClView);
            yyaxis left; axis([-inf inf -90 10]);
            yyaxis right; axis([-inf inf -200 200]);
            
            % Sliders
            figure(Parent.Interface);
            obj.sldCommonSlider = javax.swing.JSlider;
            javacomponent(obj.sldCommonSlider,pos_slider);
            set(obj.sldCommonSlider,'Value',0,'Minimum',0,'Maximum',300,...
                'MajorTickSpacing',30,'PaintLabels',true,'PaintTicks',true,...
                'Visible',0);
            set(handle(obj.sldCommonSlider,'CallbackProperties'),...
                'StateChangedCallback',@obj.move_sldCommonSlider);
            
            % Label bar initialization, needs to take care of colormap
            % and CLim later
            obj.axEmLblbar = axes(Parent.Interface,'Position',pos_labelbar,...
                'XGrid','on','XTickLabel',{},'YTick',[],'YTickMode','manual',...
                'Visible','off');
            
            obj.axAbLblbar = axes(Parent.Interface,'Position',pos_labelbar,...
                'XGrid','on','XTickLabel',{},'YTick',[],'YTickMode','manual',...
                'Visible','off');
            
            obj.axClLblbar = axes(Parent.Interface,'Position',pos_labelbar,...
                'XGrid','on','XTickLabel',{},'YTick',[],'YTickMode','manual',...
                'Visible','off');
            
            addlistener(Parent,'Mode','PostSet',@obj.modeDisplayUpdate);
            addlistener(Parent,'Emulate','PostSet',@obj.EmulateLoaded);
            addlistener(Parent,'Ablate','PostSet',@obj.AblateLoaded);
        end
    end
end
classdef Ref_SpectraLabeller < handle
    %% Handle properties
    properties (Access = public)
        h_figure        % Interface figure
        h_selectData    % Load data push button
        h_saveLabels
        h_loadLabels
        h_slider        % Frames slider
        h_ax_window     % Spectra view window
        h_ax_labelBar   % label bar indicating label status
        h_im_establishedLabel
        h_im_activeLabel
        
        h_currLbl_Label
        h_currLbl_Text
        h_currFrm_Label
        h_currFrm_Box
        h_currFrm_Goto
        h_startSelect_Label
        h_startSelect_Box
        h_startSelect_Set
        h_startSelect_Clear
        h_endSelect_Label
        h_endSelect_Box
        h_endSelect_Set
        h_endSelect_Clear
        
        H_unitLabeller Ref_UnitLabeller% handle arrays of unit labellers
    end
    %% Data properties
    properties (Access = public)
        path_app     % The path where the app runs.
        rawDataPath
        rawDataName
        RawData      % Loaded raw data
        freq         % Frequency vector
        num_frames   % How many frames (dynamics) in this raw data
        RL           % Return loss
        PA           % Phase angle
        Label        % Label Data
        LabelActive
        LabelSystem  % Label Model
        LabelColorMap
        num_labels
    end
    %% App methods
    methods (Access = public)
        
        % Constructor
        function app = Ref_SpectraLabeller()
            
            LabelSystem = load(app.LabelSystemName,'LabelSystem');
            app.LabelSystem = LabelSystem.LabelSystem;
            app.LabelColorMap = cell2mat(transpose({app.LabelSystem.Color}));
            app.num_labels = length(app.LabelSystem);
            
            % initialize interface
            init(app);
                        
        end
        
        % Destructor
        function delete(app,hObject,eventData)
            
            delete(app.h_figure);
        end
    end
    
    methods (Access = private)
        function init(app)
            app.h_figure = figure('position',app.getFigurePos,'Name','Labeller',...
                'NumberTitle','off','Resize','off','CloseRequestFcn',@app.delete,...
                'MenuBar','none','ToolBar','none'); % ,...
            %                 'WindowKeyPressFcn',@app.keyPress);
            app.h_selectData = uicontrol(app.h_figure,'Style','pushbutton',...
                'String','Select Data','position',app.getSelectDataPos(),...
                'Callback',@app.pushSelectData);
            
            app.h_currFrm_Label = uicontrol(app.h_figure,'Style','text','HorizontalAlignment','right',...
                'String','Current Frame','Position',app.getCurrFrmLblPos());
            app.h_currFrm_Box = uicontrol(app.h_figure,'Style','edit',...
                'Position',app.getCurrFrmBxPos(),...
                'Callback',@app.editCurrFrmBx);
            app.h_currFrm_Goto = uicontrol(app.h_figure,'Style','pushbutton',...
                'String','Go to', 'position',app.getCurrFrmGotoPos());
            app.h_startSelect_Label = uicontrol(app.h_figure,'Style','text','HorizontalAlignment','right',...
                'String','Start of Selection','Position',app.getStartSlctLblPos());
            app.h_startSelect_Box = uicontrol(app.h_figure,'Style','edit','Enable','off',...
                'Position',app.getStartSlctBxPos(),'String','0');
            app.h_startSelect_Set = uicontrol(app.h_figure,'Style','pushbutton',...
                'String','Set', 'position',app.getStartSlctSetPos(),...
                'Callback',@app.pushStartSlctSet);
            app.h_startSelect_Clear = uicontrol(app.h_figure,'Style','pushbutton',...
                'String','Clear', 'position',app.getStartSlctClearPos(),...
                'Callback',@app.pushStartSlctClear);
            app.h_endSelect_Label = uicontrol(app.h_figure,'Style','text','HorizontalAlignment','right',...
                'String','End of Selection','Position',app.getEndSlctLblPos());
            app.h_endSelect_Box = uicontrol(app.h_figure,'Style','edit','Enable','off',...
                'Position',app.getEndSlctBxPos(),'String','0');
            app.h_endSelect_Set = uicontrol(app.h_figure,'Style','pushbutton',...
                'String','Set', 'position',app.getEndSlctSetPos(),...
                'Callback',@app.pushEndSlctSet);
            app.h_endSelect_Clear = uicontrol(app.h_figure,'Style','pushbutton',...
                'String','Clear', 'position',app.getEndSlctClearPos(),...
                'Callback',@app.pushEndSlctClear);
            
            buildingUnitLbl_currPos = app.getFirstUnitLblPos();
            for i = 1:length(app.LabelSystem)
                app.H_unitLabeller(i) = Ref_UnitLabeller(app,...
                    buildingUnitLbl_currPos,...
                    app.LabelSystem(i).Name,...
                    app.LabelSystem(i).Color,...
                    app.LabelSystem(i).Index);
                buildingUnitLbl_currPos = [buildingUnitLbl_currPos(1),...
                    buildingUnitLbl_currPos(2)+ buildingUnitLbl_currPos(4)+15,...
                    buildingUnitLbl_currPos(3), buildingUnitLbl_currPos(4)];
            end
            
            app.h_currLbl_Label = uicontrol(app.h_figure,'Style','text','HorizontalAlignment','right',...
                'String','Current Label:','Position',app.getCurrLblLblPos());
            app.h_currLbl_Text = uicontrol(app.h_figure,'Style','text','HorizontalAlignment','left',...
                'String','','Position',app.getCurrLblTxtPos(),...
                'FontWeight','bold');
        end
    end
    
    %% Layout value properties and methods
    properties (Constant)
        figureW = 1200;
        figureH = 700;
        LabelSystemName = 'LabelSystem_Coarse9Label';
    end
    
    methods (Access = private)
        function pixelPos = ratio2pixel(app,ratioPos)
            pixelPos = ratioPos.*[app.figureW app.figureH app.figureW app.figureH];
        end
        
        function ratioPos = pixel2ratio(app,pixelPos)
            ratioPos = pixelPos./[app.figureW app.figureH app.figureW app.figureH];
        end
        
        function figurePos = getFigurePos(app)
            figurePos = [100 100 app.figureW app.figureH];
        end
        
        function selectDataPos = getSelectDataPos(app)
            axWindowPos = app.ratio2pixel(app.getAxWindowPos);
%             selectDataPos = [300 650 100 20];
            selectDataPos = [axWindowPos(1) (app.figureH+(axWindowPos(2)+axWindowPos(4)))/2,...
                100 20];
        end
        
        function saveLabelsPos = getSaveLabelsPos(app)
            selectDataPos = app.getSelectDataPos();
            saveLabelsPos = [selectDataPos(1)+selectDataPos(3)+20 selectDataPos(2) ...
                selectDataPos(3) selectDataPos(4)];
        end
        
        function loadLabelsPos = getLoadLabelsPos(app)
            saveLabelsPos = app.getSaveLabelsPos();
            loadLabelsPos = [saveLabelsPos(1)+saveLabelsPos(3)+20 saveLabelsPos(2) ...
                saveLabelsPos(3) saveLabelsPos(4)];
        end
        
        function sliderPos = getSliderPos(app)
            axWindowPos = app.ratio2pixel(app.getAxWindowPos);
            sliderPos = [axWindowPos(1) axWindowPos(2)*0.15,...
                axWindowPos(3) 45];
        end
        
        function axWindowPos = getAxWindowPos(app)
            axWindowPos_pixel = [60 120 500 500];
            axWindowPos = app.pixel2ratio(axWindowPos_pixel);
        end
        
        function axLabelBarPos = getAxLabelBarPos(app)
            sliderPos = app.getSliderPos();
            sliderMargin = sliderPos(3)*(1.62/30)*(1/2); % It's an absolute margin width. So the ratio 1.6/30 is only valid for this slider width.
            %             horizontalDifference = sliderPos(3)/double(app.num_frames);
            sliderInnerW = sliderPos(3)-sliderMargin*2;
            horizontalDifference = (0.43/app.num_frames)*sliderInnerW;
            %             axLabelBarPos_pixel = [sliderPos(1)+horizontalDifference sliderPos(2)+45,...
            %                 sliderPos(3) 15];
            axLabelBarPos_pixel = [sliderPos(1)+horizontalDifference+sliderMargin sliderPos(2)+45,...
                sliderInnerW 15];
            axLabelBarPos = app.pixel2ratio(axLabelBarPos_pixel);
        end
        
        function currFrmLblPos = getCurrFrmLblPos(app)
            axWindowPos = app.ratio2pixel(app.getAxWindowPos);
            currFrmLblPos = [axWindowPos(1)+axWindowPos(3)+50 axWindowPos(2),...
                100 20];
        end
        
        function currFrmBxPos = getCurrFrmBxPos(app)
            currFrmLblPos = app.getCurrFrmLblPos();
            currFrmBxPos = currFrmLblPos + [100 0 0 0];
        end
        
        function currFrmGotoPos = getCurrFrmGotoPos(app)
            currFrmLblPos = app.getCurrFrmLblPos();
            currFrmGotoPos = (currFrmLblPos + [200 0 0 0])...
                .*[1 1 0.5 1];
        end
        
        function startSlctLblPos = getStartSlctLblPos(app)
            currFrmLblPos = app.getCurrFrmLblPos();
            startSlctLblPos = currFrmLblPos + [0 -30 0 0];
        end
        
        function startSlctBxPos = getStartSlctBxPos(app)
            currFrmLblPos = app.getCurrFrmLblPos();
            startSlctBxPos = currFrmLblPos + [100 -30 0 0];
        end
        
        function startSlctSetPos = getStartSlctSetPos(app)
            currFrmLblPos = app.getCurrFrmLblPos();
            startSlctSetPos = (currFrmLblPos + [200 -30 0 0])...
                .*[1 1 0.5 1];            
        end
        
        function startSlctClearPos = getStartSlctClearPos(app)
            currFrmLblPos = app.getCurrFrmLblPos();
            startSlctClearPos = (currFrmLblPos + [250 -30 0 0])...
                .*[1 1 0.5 1];
        end
        
        function endSlctLblPos = getEndSlctLblPos(app)
            currFrmLblPos = app.getCurrFrmLblPos();
            endSlctLblPos = currFrmLblPos + [0 -60 0 0];
        end
        
        function endSlctBxPos = getEndSlctBxPos(app)
            currFrmLblPos = app.getCurrFrmLblPos();
            endSlctBxPos = currFrmLblPos + [100 -60 0 0];
        end
        
        function endSlctSetPos = getEndSlctSetPos(app)
            currFrmLblPos = app.getCurrFrmLblPos();
            endSlctSetPos = (currFrmLblPos + [200 -60 0 0])...
                .*[1 1 0.5 1];
        end
        
        function endSlctClearPos = getEndSlctClearPos(app)
            currFrmLblPos = app.getCurrFrmLblPos();
            endSlctClearPos = (currFrmLblPos + [250 -60 0 0])...
                .*[1 1 0.5 1];
        end
        
        function firstUnitLblPos = getFirstUnitLblPos(app)
            currFrmLblPos = app.getCurrFrmLblPos();
            firstUnitLblPos = [currFrmLblPos(1)+100 currFrmLblPos(2)+100 currFrmLblPos(3)/4 currFrmLblPos(4)];
        end
        
        function currLblLblPos = getCurrLblLblPos(app)
            currFrmLblPos = app.getCurrFrmLblPos();
            currLblLblPos = [currFrmLblPos(1) currFrmLblPos(2)+currFrmLblPos(4) currFrmLblPos(3) currFrmLblPos(4)];
        end
        
        function currLblTxtPos = getCurrLblTxtPos(app)
            currFrmLblPos = app.getCurrFrmLblPos();
            currLblTxtPos = [currFrmLblPos(1)+currFrmLblPos(3) currFrmLblPos(2)+currFrmLblPos(4) currFrmLblPos(3)*2 currFrmLblPos(4)];
        end
        
    end
    %% Callbacks
    methods (Access = private)
        
%         function keyPress(app,hObject,eventData)
%             switch eventData.Modifier{1}
%                 case 'alt'
%                     switch eventData.Key
%                         case 'q'
%                             pushStartSlctSet(app,[]);
%                             disp('q');
%                         case 'w'
%                             disp('w');
%                         case 'a'
%                             disp('a');
%                         case 's'
%                             disp('s');
%                     end
%             end
%         end
        
        function pushSelectData(app,hObject,eventData)
            [RawDataName, RawDataPath, ~] = uigetfile(['*.csv']);
            app.rawDataPath = RawDataPath;
            app.rawDataName = RawDataName;
            
            if(RawDataName)
                % initialize data
                app.RawData = csvread([RawDataPath, filesep, RawDataName]);
                
                app.num_frames = (size(app.RawData,2)-1)/2;
                app.freq = app.RawData(:,1);
                app.RL = NaN(size(app.RawData,1),app.num_frames);
                app.PA = NaN(size(app.RawData,1),app.num_frames);
                
                for i_frame = 1:app.num_frames
                    % the factor 20 here could be 10, but Nov21 data was
                    % labelled and saved as 20, so stay this way for now
                    app.RL(:,i_frame) = 20*log10(app.RawData(:,i_frame*2).^2+app.RawData(:,i_frame*2+1).^2);
                    app.PA(:,i_frame) = atan2(app.RawData(:,i_frame*2+1),app.RawData(:,i_frame*2))/pi*180;
                end
                app.RawData = [];
                
                % Label init
                app.Label = zeros(1,app.num_frames);
                app.LabelActive = false(1,app.num_frames);
                
                % initialize data views
                % Creat axes
                app.h_ax_window = axes(app.h_figure,'position',app.getAxWindowPos);
                yyaxis left;
                plot(app.h_ax_window,app.freq,app.RL(:,1),'b-'); axis([-inf inf -90 10]);
                yyaxis right;
                plot(app.h_ax_window,app.freq,app.PA(:,1),'r--'); axis([-inf inf -200 200]);
                
                % Creat slider
                %                 app.h_slider = uicontrol(app.h_figure,'Style','slider','position',app.getSliderPos,...
                %                     'Min',1,'Max',app.num_frames,'Value',1,...
                %                     'SliderStep',[1/(2*app.num_frames) 2/app.num_frames]);
                app.h_slider = javax.swing.JSlider;
                javacomponent(app.h_slider,app.getSliderPos);
                set(app.h_slider,'Value',1,'MajorTickSpacing',ceil(app.num_frames/35)*5,'PaintLabels',true,'PaintTicks',true);
                set(app.h_slider,'Minimum',0);
                set(app.h_slider,'Maximum',app.num_frames);
                %                 hSliderCallback = handle(app.h_slider,'CallbackProperties');
                %                 hSliderCallback.StateChangedCallback = @app.moveSlider;
%                 set(hSliderCallback,'StateChangedCallback',@app.moveSlider);
                set(handle(app.h_slider,'CallbackProperties'),'StateChangedCallback',@app.moveSlider);
                
                % label bar init
                axLabelBarPos = app.getAxLabelBarPos();
                app.h_ax_labelBar = axes(app.h_figure,'position',axLabelBarPos);
                app.h_im_establishedLabel = imagesc(app.h_ax_labelBar,app.Label);
                colormap(app.h_ax_labelBar,app.LabelColorMap);
                set(app.h_ax_labelBar,'XGrid','on','YTick',[]);
                app.h_ax_labelBar.CLim = [0, app.num_labels];
                
                % test active area indicator
                %                 app.h_ax_labelBar; hold on;
                %                 labelMask_temp = zeros([size(app.Label),3]);
                %                 labelMask_temp(:,:,1) = [zeros(1,7) ones(1,17) zeros(1,6)];
                %                 h = imagesc(labelMask_temp);
                %                 set(h,'AlphaData',[zeros(1,7) ones(1,17) zeros(1,6)]);
                %                 hold off;
                
                set(app.h_currFrm_Box,'String','1');
                set(app.h_currLbl_Text,'String',app.LabelSystem(app.Label(1)+1).Name);
                
                app.h_saveLabels = uicontrol(app.h_figure,'Style','pushbutton',...
                    'String','Save Labels','position',app.getSaveLabelsPos(),...
                    'Callback',@app.pushSaveLabels);
                app.h_loadLabels = uicontrol(app.h_figure,'Style','pushbutton',...
                    'String','Load Labels','position',app.getLoadLabelsPos(),...
                    'Callback',@app.pushLoadLabels);
                
                %                 addlistener(app.h_slider,'ContinuousValueChange',@app.moveSlider);
            end
        end
        
        function pushSaveLabels(app, hObject, eventData)
            [SaveName, SavePath, ~] = uiputfile([app.rawDataPath,filesep,'Labelled_',app.rawDataName(1:end-4),'.mat']);
            
            if(SaveName)
                freq = app.freq;
                num_frames = app.num_frames;
                num_labels = app.num_labels;
                RL = app.RL;
                PA = app.PA;
                Label = app.Label;
                LabelSystem = app.LabelSystem;
                save([SavePath,filesep,SaveName],'freq','num_frames','num_labels','RL','PA','Label','LabelSystem');
            end
        end
        
        function pushLoadLabels(app,hObject,eventData)
            [LoadLabelName, LoadLabelPath, ~] = uigetfile(['*.mat']);
            
            if(LoadLabelName)
                load([LoadLabelPath filesep LoadLabelName],'num_frames','Label');
                if(num_frames == app.num_frames)
                    app.Label = Label;
                    set(app.h_startSelect_Box,'String','');
                    set(app.h_endSelect_Box,'String','');
                    app.LabelActive(:) = false;
                    delete(app.h_im_activeLabel);
                    set(app.h_im_establishedLabel,'CData',app.Label);
                    
                    i_frame = int32(get(app.h_slider,'Value'));
                    if(i_frame < 1 || i_frame > app.num_frames)
                    else
                        set(app.h_currLbl_Text,'String',app.LabelSystem(app.Label(i_frame)+1).Name);
                    end
                    drawnow;
                end
            end
            
        end
        
        function moveSlider(app,hObject,eventData)
            i_frame = int32(get(hObject,'Value'));
            if(i_frame < 1 || i_frame > app.num_frames)
                axes(app.h_ax_window);
                yyaxis right;
                cla(app.h_ax_window);
                yyaxis left;
                cla(app.h_ax_window);
                set(app.h_currFrm_Box,'String',i_frame);
                set(app.h_currLbl_Text,'String','');
                drawnow;
            else
                axes(app.h_ax_window);
                yyaxis left;
                plot(app.h_ax_window,app.freq,app.RL(:,i_frame),'b-'); axis([-inf inf -90 10]);
                yyaxis right;
                plot(app.h_ax_window,app.freq,app.PA(:,i_frame),'r--'); axis([-inf inf -200 200]);
                set(app.h_currFrm_Box,'String',i_frame);
                set(app.h_currLbl_Text,'String',app.LabelSystem(app.Label(i_frame)+1).Name);
                drawnow;
            end
        end
        
        function editCurrFrmBx(app,hObject,eventData)
            i_currFrm = int32(str2double(get(hObject,'String')));
            %             if(i_currFrm < 1 || i_currFrm > app.num_frames)
            if(i_currFrm < 1)
                axes(app.h_ax_window);
                yyaxis right;
                cla(app.h_ax_window);
                yyaxis left;
                cla(app.h_ax_window);
                set(app.h_currLbl_Text,'String','');
                set(app.h_slider,'Value',0);
                set(app.h_currFrm_Box,'String',0);
                drawnow;
            elseif(i_currFrm > app.num_frames)
                axes(app.h_ax_window);
                yyaxis right;
                cla(app.h_ax_window);
                yyaxis left;
                cla(app.h_ax_window);
                set(app.h_slider,'Value',app.num_frames);
                set(app.h_currLbl_Text,'String',app.LabelSystem(app.Label(app.num_frames)+1).Name);
                set(app.h_currFrm_Box,'String',app.num_frames);
                drawnow;                
            else
                axes(app.h_ax_window);
                yyaxis left;
                plot(app.h_ax_window,app.freq,app.RL(:,i_currFrm),'b-'); axis([-inf inf -90 10]);
                yyaxis right;
                plot(app.h_ax_window,app.freq,app.PA(:,i_currFrm),'r--'); axis([-inf inf -200 200]);
                set(app.h_currLbl_Text,'String',app.LabelSystem(app.Label(i_currFrm)+1).Name);
                set(app.h_slider,'Value',i_currFrm);
                drawnow;
            end
        end
        
        function pushStartSlctSet(app,~,~)
            set(app.h_startSelect_Box,'String',app.h_currFrm_Box.String);
            i_endFrm = int32(str2double(app.h_endSelect_Box.String));
            if((i_endFrm > 0) && (i_endFrm <= app.num_frames))
                i_startFrm = int32(str2double(app.h_startSelect_Box.String));
                if((i_startFrm > 0) && (i_startFrm <= app.num_frames))
                    i_slctFrm_1 = min([i_startFrm, i_endFrm]);
                    i_slctFrm_2 = max([i_startFrm, i_endFrm]);
                    app.LabelActive(i_slctFrm_1:i_slctFrm_2) = true;
                    
                    labelMask_temp = zeros([size(app.Label),3]);
                    labelMask_temp(:,:,1) = double(app.LabelActive);
                    set(app.h_ax_labelBar,'NextPlot','add');
                    app.h_im_activeLabel = imagesc(app.h_ax_labelBar,labelMask_temp);
                    set(app.h_im_activeLabel,'AlphaData',double(app.LabelActive));
                end
            end
        end

        function pushStartSlctClear(app,~,~)
            set(app.h_startSelect_Box,'String','');
            app.LabelActive(:) = false;
            delete(app.h_im_activeLabel);
        end
                        
        function pushEndSlctSet(app,~,~)
            set(app.h_endSelect_Box,'String',app.h_currFrm_Box.String);
            i_startFrm = int32(str2double(app.h_startSelect_Box.String));
            if((i_startFrm > 0) && (i_startFrm <= app.num_frames))
                i_endFrm = int32(str2double(app.h_endSelect_Box.String));
                if((i_endFrm > 0) && (i_endFrm <= app.num_frames))
                    i_slctFrm_1 = min([i_startFrm, i_endFrm]);
                    i_slctFrm_2 = max([i_startFrm, i_endFrm]);
                    app.LabelActive(i_slctFrm_1:i_slctFrm_2) = true;
                    
                    labelMask_temp = zeros([size(app.Label),3]);
                    labelMask_temp(:,:,1) = double(app.LabelActive);
                    set(app.h_ax_labelBar,'NextPlot','add');
                    app.h_im_activeLabel = imagesc(app.h_ax_labelBar,labelMask_temp);
                    set(app.h_im_activeLabel,'AlphaData',double(app.LabelActive));
                    
                end
            end
        end

        function pushEndSlctClear(app,~,~)
            set(app.h_endSelect_Box,'String','');
            app.LabelActive(:) = false;
            delete(app.h_im_activeLabel);
        end
        

    end
end
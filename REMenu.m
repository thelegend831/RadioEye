classdef REMenu < handle
    %% Parameters
    properties
        Parent
        Position
    end
    %% UI Controls
    properties
        % pushbuttons for emulate
        pbEmSelectData
        pbEmSelectClassifier
        pbEmSaveData
        
        % pushbuttons for ablate
        pbAbNewTreatment
        pbAbSaveData
        
        % pushbuttons for calibrate
        pbClSelectData
        pbClLoadLabels
        pbClSaveLabels
    end
    %% Callback methods
    methods
        function updateDisplay(obj,src,edata)
            switch edata.AffectedObject.Mode
                case 'Emulate'
                    obj.hideAb();
                    obj.hideCl();
                    obj.displayEm();
                case 'Ablate'
                    obj.hideEm();
                    obj.hideCl();
                    obj.displayAb();
                case 'Calibrate'
                    obj.hideEm();
                    obj.hideAb();
                    obj.displayCl();
            end
        end
        
        function displayEm(obj)
            obj.pbEmSelectData.Visible = 'on';
            obj.pbEmSelectClassifier.Visible = 'on';
            obj.pbEmSaveData.Visible = 'on';
        end
        
        function displayAb(obj)
            obj.pbAbNewTreatment.Visible = 'on';
            obj.pbAbSaveData.Visible = 'on';
        end
        
        function displayCl(obj)
            obj.pbClSelectData.Visible = 'on';
            obj.pbClLoadLabels.Visible = 'on';
            obj.pbClSaveLabels.Visible = 'on';
        end
        
        function hideEm(obj)
            obj.pbEmSelectData.Visible = 'off';
            obj.pbEmSelectClassifier.Visible = 'off';
            obj.pbEmSaveData.Visible = 'off';
        end
        
        function hideAb(obj)
            obj.pbAbNewTreatment.Visible = 'off';
            obj.pbAbSaveData.Visible = 'off';
        end
        
        function hideCl(obj)
            obj.pbClSelectData.Visible = 'off';
            obj.pbClLoadLabels.Visible = 'off';
            obj.pbClSaveLabels.Visible = 'off';
        end
        
        function push_pbEmSelectData(obj,src,edata)
            [RawDataName,RawDataPath,~] = uigetfile(['*.csv'],'Select emulation raw data');
            [LabelDataName,~,~] = uigetfile(['*.mat'],'Select emulation label data (optional)');
            if(RawDataName)
                % delete previous emulation object
                delete(obj.Parent.Emulate);
                % create new emulation object
                obj.Parent.Emulate = REEmulate(obj.Parent,RawDataPath,RawDataName,LabelDataName);
            end
        end
        function push_pbAbNewTreatment(obj,src,edata)
            obj.Parent.Ablate.delete();
            obj.Parent.Ablate = REAblate(obj.Parent);
        end
        function push_pbAbSaveData(obj,src,edata)
            h_Ablate = obj.Parent.Ablate;
            [RawSaveName, RawSavePath, ~] = uiputfile('*.csv');
            [LblSaveName, LblSavePath, ~] = uiputfile('*.mat');
            
            if(RawSaveName)
                csvwrite([RawSavePath filesep RawSaveName],obj.Parent.Ablate.RawData);
            end
            if(LblSaveName)
                freq = h_Ablate.acqFreq;
                num_frames = h_Ablate.numAcqFrames;
                num_labels = length(h_Ablate.LabelSystem);
                RL = h_Ablate.RL;
                PA = h_Ablate.PA;
                Label = h_Ablate.Label;
                LabelSystem = h_Ablate.LabelSystem;
                save([LblSavePath filesep LblSaveName],'freq','num_frames','num_labels','RL','PA','Label','LabelSystem');
            end
        end
        
    end
    %% Obj methods
    methods
        function obj = REMenu(Parent,Position,Mode)
            obj.Parent = Parent;
            obj.Position = Position;
            
            x = Position(1); y = Position(2); W = Position(3); H = Position(4);
            unitW = W/4; gapW = W/15;
            pos_pb1 = [x y unitW H];
            pos_pb2 = [x+unitW+gapW y unitW H];
            pos_pb3 = [x+2*(unitW+gapW) y unitW H];
            
            obj.pbEmSelectData = uicontrol(Parent.Interface,'Style','pushbutton',...
                'String','Select Data','Position',pos_pb1,'Visible','off',...
                'Callback',@obj.push_pbEmSelectData);
            obj.pbEmSelectClassifier = uicontrol(Parent.Interface,'Style','pushbutton',...
                'String','Select Classifier','Position',pos_pb2,'Visible','off',...
                'Callback',@obj.push_pbEmSelectClassifier);
            obj.pbEmSaveData = uicontrol(Parent.Interface,'Style','pushbutton',...
                'String','Save Data','Position',pos_pb3,'Visible','off',...
                'Callback',@obj.push_pbEmSaveData);
            
            obj.pbAbNewTreatment = uicontrol(Parent.Interface,'Style','pushbutton',...
                'String','New Treatment','Position',pos_pb2,'Visible','off',...
                'Callback',@obj.push_pbAbNewTreatment);
            obj.pbAbSaveData = uicontrol(Parent.Interface,'Style','pushbutton',...
                'String','Save Data','Position',pos_pb3,'Visible','off',...
                'Callback',@obj.push_pbAbSaveData);
            
            obj.pbClSelectData = uicontrol(Parent.Interface,'Style','pushbutton',...
                'String','Select Data','Position',pos_pb1,'Visible','off',...
                'Callback',@obj.push_pbEmSelectData);
            obj.pbClLoadLabels = uicontrol(Parent.Interface,'Style','pushbutton',...
                'String','Load Labels','Position',pos_pb2,'Visible','off',...
                'Callback',@obj.push_pbClLoadLabels);
            obj.pbClSaveLabels = uicontrol(Parent.Interface,'Style','pushbutton',...
                'String','Save Labels','Position',pos_pb3,'Visible','off',...
                'Callback',@obj.push_pbClSaveLabels);
            
            switch Mode
                case 'Emulate'
                    obj.displayEm();
                case 'Ablate'
                    obj.displayAb();
                case 'Calibrate'
                    obj.displayCl();
            end
            
            addlistener(Parent,'Mode','PostSet',@obj.updateDisplay);
        end
    end
end
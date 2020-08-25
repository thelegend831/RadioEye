classdef REEmOperationPanel < handle
    properties
        Parent
        Position
    end
    properties
        psNumAcq REParameterSet % ps -- parameter set combination
        
        psTimePerAcq REParameterSet
        
        txSamplingMode
        puSamplingMode
        
        txClassifier
        puClassifier
        
        pbRun
    end
    methods
        function modeDisplayUpdate(obj,src,edata)
            switch edata.AffectedObject.Mode
                case 'Emulate'
                    obj.turnOnPanel();
                case 'Ablate'
                    obj.turnOffPanel();
                case 'Calibrate'
                    obj.turnOffPanel();
            end
        end
        function valueDisplayUpdate(obj,numAcq,timePerAcq,samplingMode,classifier)
            obj.psNumAcq.bxValue.String = num2str(numAcq);
            obj.psTimePerAcq.bxValue.String = num2str(timePerAcq);
            obj.puSamplingMode.Value = samplingMode;
            obj.puClassifier.Value = classifier;
        end
        function turnOnPanel(obj)
            obj.psNumAcq.Visible = 'on';
            obj.psTimePerAcq.Visible = 'on';
            obj.txSamplingMode.Visible = 'on';
            obj.puSamplingMode.Visible = 'on';
            obj.txClassifier.Visible = 'on';
            obj.puClassifier.Visible = 'on';
            obj.pbRun.Visible = 'on';
        end
        function turnOffPanel(obj)
            obj.psNumAcq.Visible = 'off';
            obj.psTimePerAcq.Visible = 'off';
            obj.txSamplingMode.Visible = 'off';
            obj.puSamplingMode.Visible = 'off';
            obj.txClassifier.Visible = 'off';
            obj.puClassifier.Visible = 'off';
            obj.pbRun.Visible = 'off';
        end
        function set_psNumAcq(obj,src,edata)
            obj.Parent.Emulate.numAcqFrames = double(int32(str2double(get(src,'String'))));
        end
        function set_psTimePerAcq(obj,src,edata)
            obj.Parent.Emulate.secPerFrame = str2num(get(src,'String'));
        end
        function slct_puSamplingMode(obj,src,edata)
            samplingModeEnum = {'Sequential','Random'};
            obj.Parent.Emulate.samplingMode = samplingModeEnum{src.Value};
        end
        function slct_puClassifier(obj,src,edata)
            classifierEnum = {'NormalizationNN5','NormalizationLasso'};
            delete(obj.Parent.Emulate.Classifier);
            obj.Parent.Emulate.Classifier = REClassifier(classifierEnum{src.Value});
        end
        function push_pbRun(obj,src,edata)
            obj.Parent.Emulate.run();
        end
           
    end
    methods
        function obj = REEmOperationPanel(Parent,Position)
            obj.Parent = Parent;
            obj.Position = Position;
            x = Position(1); y = Position(2); W = Position(3); H = Position(4);
            unitH = H*20/140; gapH = H*10/140; unitW = W*100/300;
            pos_5 = [x+unitW y 2*unitW unitH];
            pos_4_1 = [x y+(unitH+gapH) unitW unitH];
            pos_4_2 = [x+unitW y+(unitH+gapH) 2*unitW unitH];
            pos_3_1 = [x y+2*(unitH+gapH) unitW unitH];
            pos_3_2 = [x+unitW y+2*(unitH+gapH) 2*unitW unitH];
            pos_2 = [x y+3*(unitH+gapH) W unitH];
            pos_1 = [x y+4*(unitH+gapH) W unitH];
            
            obj.psNumAcq = REParameterSet(obj,Parent.Interface,pos_1,'Number of Acquisitions','Set');
            set(obj.psNumAcq.bxValue,'Callback',@obj.set_psNumAcq);
            
            obj.psTimePerAcq = REParameterSet(obj,Parent.Interface,pos_2,'Time per Acquisition','Set');
            set(obj.psTimePerAcq.bxValue,'Callback',@obj.set_psTimePerAcq);
            
            obj.txSamplingMode = uicontrol(Parent.Interface,'Style','text','HorizontalAlignment','right',...
                'String','Sampling','Position',pos_3_1,'Visible','off');
            obj.puSamplingMode = uicontrol(Parent.Interface,'Style','popup',...
                'String',{'Sequential','Random'},'Position',pos_3_2,'Visible','off',...
                'Callback',@obj.slct_puSamplingMode);
            
            obj.txClassifier = uicontrol(Parent.Interface,'Style','text','HorizontalAlignment','right',...
                'String','Classifier','Position',pos_4_1,'Visible','off');
            obj.puClassifier = uicontrol(Parent.Interface,'Style','popup',...
                'String',{'Normalization NN = 5','Normalization Lasso'},'Position',pos_4_2,'Visible','off',...
                'Callback',@obj.slct_puClassifier);
            
            obj.pbRun = uicontrol(Parent.Interface,'Style','pushbutton',...
                'String','Run','Position',pos_5,'Visible','off',...
                'Callback',@obj.push_pbRun);
            
            addlistener(Parent,'Mode','PostSet',@obj.modeDisplayUpdate);
        end
    end
end
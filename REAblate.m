classdef REAblate < handle
    properties
        % Get from the parent
        Parent
        Path
        File
        LabelSystem
    end
    properties (SetObservable)
        numAcqFrames
        secPerFrame
        samplingMode
        Classifier
        currFrame % current frame index, indicating treatment progress
    end
    properties
        % To load
        acqFreq
        TestData
        device
        
        % To fill out
        RawData
        RL
        PA
        Label
        Accuracy
        AcPerClass
    end
    
    methods
        function loadLabelSystem(obj)
            LabelSystem_temp = load(['LabelSystem_' obj.Parent.AbLabelSystemName '.mat']);
            obj.LabelSystem = LabelSystem_temp.LabelSystem;
        end
        function [rawRE,rawIM] = feed(obj)
            switch obj.samplingMode
                case 'Treatment'
                    r = obj.device;
                    invoke(r.scpi.trigger.sequence,'single');
                    newdata = r.scpi.get('calculate',1).selected.data.sdata;
                    rawRE = newdata(1:2:end).';
                    rawIM = newdata(2:2:end).';
                case 'Test'
                    rawRE = obj.TestData(:,obj.currFrame*2);
                    rawIM = obj.TestData(:,obj.currFrame*2+1);
            end
        end
        function run(obj)
            switch obj.samplingMode
                case 'Treatment'
                    % connect to instrument
                    try
                        r=actxserver('S2VNA.Application');
                    catch
                        msgbox(['Make sure the VNA COM server is registered. At a command ',...
                            'prompt, enter c:\vna\trvna\trvna.exe -regserver and wait ',...
                            'for confirmation of sucessful registration'],'Device NOT Found');
                        return;
                    end
                    obj.device = r;
                    isready=r.ready;
                    iter=0;
                    
                    % check/wait for ready
                    while ~isready,
                        pause(1)
                        iter = iter+1;
                        isready = r.ready;
                        if(iter > 15)
                            msgbox(['Error with the connection to the instrument. Is it connected ',...
                                'by USB?'],'time Out');
                        end
                    end
                    
                    % instrument configuration (optional)
                    r.scpi.get('sense',1).frequency.start = 50e6;
                    r.scpi.get('sense',1).frequency.stop = 2.0e9;
                    % etc.
                    set(r.scpi.TRIGger.SEQuence,'SOURce','bus');
                    obj.acqFreq = r.scpi.get('sense',1).frequency.data;
                    obj.RawData = NaN(length(obj.acqFreq),1+2*obj.numAcqFrames);
                    obj.RawData(:,1) = obj.acqFreq;
                    obj.RL = NaN(size(obj.RawData,1),obj.numAcqFrames);
                    obj.PA = NaN(size(obj.RawData,1),obj.numAcqFrames);
                    
                    for i = 1:obj.numAcqFrames
                        timer = tic;
                        [rawRE, rawIM] = obj.feed();
                        obj.RawData(:,obj.currFrame*2) = rawRE;
                        obj.RawData(:,obj.currFrame*2+1) = rawIM;
                        [obj.RL(:,obj.currFrame),obj.PA(:,obj.currFrame),obj.Label(obj.currFrame)]...
                            = obj.Classifier.getLabel(obj.acqFreq,rawRE,rawIM);
                        obj.currFrame = obj.currFrame+1;
                        pause(obj.secPerFrame-toc(timer));
                    end
                    
                    set(r.scpi.TRIGger.SEQuence,'SOURce','int');
                    r.scpi.get('initiate',1).continuous = 1;
                    
                case 'Test'
                    obj.acqFreq = obj.TestData(:,1);
                    obj.RawData = NaN(length(obj.acqFreq),1+2*obj.numAcqFrames);
                    obj.RawData(:,1) = obj.acqFreq;
                    obj.RL = NaN(size(obj.RawData,1),obj.numAcqFrames);
                    obj.PA = NaN(size(obj.RawData,1),obj.numAcqFrames);
                    for i = 1:obj.numAcqFrames
                        timer = tic;
                        [rawRE,rawIM] = obj.feed();
                        obj.RawData(:,obj.currFrame*2) = rawRE;
                        obj.RawData(:,obj.currFrame*2+1) = rawIM;
                        [obj.RL(:,obj.currFrame),obj.PA(:,obj.currFrame),obj.Label(obj.currFrame)]...
                            = obj.Classifier.getLabel(obj.acqFreq,rawRE,rawIM);
                        obj.currFrame = obj.currFrame+1;
                        pause(obj.secPerFrame-toc(timer));
                    end
            end
        end
    end
    
    methods
        function obj = REAblate(Parent)
            obj.Parent = Parent;
            obj.loadLabelSystem();
            obj.TestData = csvread('AbTestData.csv');
            
            obj.secPerFrame = 1/3;
            obj.samplingMode = 'Treatment';
            obj.Classifier = REClassifier('NormalizationNN5');
            
            obj.numAcqFrames = 300; % default acquisition frame number
            obj.currFrame = 1;
            obj.Label = zeros(1,obj.numAcqFrames);
            
            % Inform the interface
            Parent.AbOperationPanel.valueDisplayUpdate(obj.numAcqFrames,obj.secPerFrame,1,1);
        end
    end
end
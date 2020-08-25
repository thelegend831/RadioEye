classdef REEmulate < handle
    properties
        % Get from the parent
        Parent
        Path
        File
        LabelFile % if true, display truth label results; if false, display computer label only
        LabelSystem
    end
    properties (SetObservable)
        numAcqFrames
        secPerFrame
        samplingMode
        Classifier % label = classifier(rawRE, rawIM);
        currFrame % current frame index, indicating treatment progress
    end
    properties
        % To load
        RawData
        TruthLabel
        acqFreq
        numTotFrames
        randSequence
        
        % To fill out
        RL
        PA
        Label
        Accuracy
        AcPerClass
    end
    
    methods
        function loadLabelSystem(obj)
            LabelSystem_temp = load(['LabelSystem_' obj.Parent.EmLabelSystemName '.mat']);
            obj.LabelSystem = LabelSystem_temp.LabelSystem;
        end
        function [rawRE,rawIM] = feed(obj)
            switch obj.samplingMode
                case 'Sequential'
                    rawRE = obj.RawData(:,obj.currFrame*2);
                    rawIM = obj.RawData(:,obj.currFrame*2+1);
                case 'Random'
                    rawRE = obj.RawData(:,obj.randSequence(obj.currFrame)*2);
                    rawIM = obj.RawData(:,obj.randSequence(obj.currFrame)*2+1);
            end
        end
        function run(obj)
            for i = 1:obj.numAcqFrames
                timer = tic;
                [rawRE,rawIM] = obj.feed();
                [obj.RL(:,obj.currFrame),obj.PA(:,obj.currFrame),obj.Label(obj.currFrame)]...
                    = obj.Classifier.getLabel(obj.acqFreq,rawRE,rawIM);
                obj.currFrame = obj.currFrame+1;
                pause(obj.secPerFrame-toc(timer));
            end
        end
    end
    
    methods
        function obj = REEmulate(Parent,Path,File,LabelFile)
            obj.Parent = Parent;
            obj.Path = Path;
            obj.File = File;
            obj.loadLabelSystem();
            
            obj.secPerFrame = 0.5;
            obj.samplingMode = 'Sequential';
            obj.Classifier = REClassifier('NormalizationNN5');
            
            obj.RawData = csvread([Path filesep File]);
            obj.LabelFile = LabelFile;
            if(LabelFile)
                obj.TruthLabel = getfield(load([Path filesep LabelFile],'Label'),'Label');
            end
            obj.acqFreq = obj.RawData(:,1);
            obj.numTotFrames = (size(obj.RawData,2)-1)/2;
            obj.numAcqFrames = obj.numTotFrames; % default acquisition frame number
            obj.randSequence = randsample(obj.numTotFrames,obj.numAcqFrames);
            
            obj.currFrame = 1;
            obj.RL = NaN(size(obj.RawData,1),obj.numAcqFrames);
            obj.PA = NaN(size(obj.RawData,1),obj.numAcqFrames);
            obj.Label = zeros(1,obj.numAcqFrames);
            
            % Inform the interface
            Parent.EmOperationPanel.valueDisplayUpdate(obj.numAcqFrames,obj.secPerFrame,1,1);
        end
    end
end
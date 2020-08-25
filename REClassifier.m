classdef REClassifier < handle
    properties
        ClassifierName
        TrainingFile = 'TrainingData.mat';
    end
    properties
        interpFreq
        TrnX
        TrnLabel
        ind_label
        num_label
    end
    methods
        function preprocess(obj,TrnClassSet)
            switch obj.ClassifierName
                case 'NormalizationNN5'
                    trnSlct = find((TrnClassSet.Label ~= 0));
                    
                    TrnX = TrnClassSet.RLPA(:,trnSlct);
                    obj.TrnLabel = TrnClassSet.Label(trnSlct);
                    
                    obj.ind_label = unique(obj.TrnLabel);
                    obj.num_label = length(obj.ind_label);
                    obj.interpFreq = TrnClassSet.freq;
                    
                    obj.TrnX = [normc(TrnX(1:(end/2),:)); normc(TrnX((end/2+1):end,:))]/sqrt(2);
                case 'NormalizationLasso'
            end
        end
    end
    methods
        function obj = REClassifier(ClassifierName)
            obj.ClassifierName = ClassifierName;
            TrnClassSet = getfield(load('TrainingData.mat','TrnClassSet'),'TrnClassSet');
            obj.preprocess(TrnClassSet);
        end
    end
    methods
        function [rawRL,rawPA,label] = getLabel(obj,acqFreq,rawRE,rawIM)
            rawRL = 20*log10(rawRE.^2+rawIM.^2);
            rawPA = atan2(rawIM,rawRE)/pi*180;
            interpRL = interp1(acqFreq,rawRL,obj.interpFreq);
            interpPA = interp1(acqFreq,rawPA,obj.interpFreq);
            interpRLPA = [normc(interpRL); normc(interpPA)]/sqrt(2);
            switch obj.ClassifierName
                case 'NormalizationNN5'
                    [~,NNInd] = sort(obj.TrnX.'*interpRLPA,1,'descend');
                    label = mode(obj.TrnLabel(NNInd(1:5)));
            end
        end
    end
end
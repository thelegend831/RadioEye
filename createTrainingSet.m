clc
clear all
close all

OutputFolder = '/Users/liuxiaoyang/Documents/Paul_A_Bottomley/AblationSensor/MATLAB/RadioEye/';
OutputName = 'TrainingData.mat';
FrequencyRange = [50e6,2000e6]; % Hz
FrequencyResolution = 10e6; % Hz
% Make sure the following files from a consistent labeling system
InputLabelFiles = {'/Users/liuxiaoyang/Documents/Paul_A_Bottomley/AblationSensor/AblationRawData/Nov21_ablationSensingExperiment/TRVNA_Data/run1/label_reassign.mat',...
    '/Users/liuxiaoyang/Documents/Paul_A_Bottomley/AblationSensor/AblationRawData/Nov21_ablationSensingExperiment/TRVNA_Data/run5/label_reassign.mat',...
    '/Users/liuxiaoyang/Documents/Paul_A_Bottomley/AblationSensor/AblationRawData/Nov21_ablationSensingExperiment/TRVNA_Data/run6/label_reassign.mat'};

%% Forming Training Set
interpFreq = (FrequencyRange(1):FrequencyResolution:FrequencyRange(2)).';
RLPA = cell(1,length(InputLabelFiles));
LabelConcat = cell(1,length(InputLabelFiles));
LabelSystemConcat = cell(1,length(InputLabelFiles));

for iF = 1:length(InputLabelFiles)
    labelFile = InputLabelFiles{iF};
    load(labelFile,'Label','LabelSystem','freq','RL','PA','num_frames');
    interpRL = zeros(length(interpFreq),size(RL,2));
    interpPA = zeros(length(interpFreq),size(PA,2));
    for iC = 1:num_frames
        interpRL(1:end,iC) = interp1(freq,RL(1:end,iC),interpFreq);
        interpPA(1:end,iC) = interp1(freq,PA(1:end,iC),interpFreq);
    end
    RLPA{iF} = [normc(interpRL); normc(interpPA)]/sqrt(2);
    LabelConcat{iF} = Label;
    LabelSystemConcat{iF} = LabelSystem;
end
TrnClassSet.freq = interpFreq;
TrnClassSet.Label = cell2mat(LabelConcat);
TrnClassSet.LabelSystem = LabelSystemConcat{1};
TrnClassSet.RLPA = cell2mat(RLPA);

save([OutputFolder,filesep,OutputName],'TrnClassSet');
clear
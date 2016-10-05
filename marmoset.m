function marmoset


%% load nii
DataDir = '/Users/shumpei/Documents/20160908_Glaucoma';

% focus on one subject
Subj = fullfile(DataDir,'TEST');

% load
dwi_raw =  niftiRead('03MyelinMap01finals70001a001.nii');
T1 = niftiRead('03T1WITI1300s100001a001.nii');

dwi = niftiRead('dti_dwi.nii');
tensor = niftiRead('dti_tensor.nii');
adc = niftiRead('dti_adc.nii');
%% 
gtable = csvread('gradient_simens30.csv');

%%
dtiInit(dwi,T1)


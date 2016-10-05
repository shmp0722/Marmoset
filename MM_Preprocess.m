function MM_Preprocess(subDir)

% Preprocessing the diffusion MRI data obtained by SIEMENS 3T scanner in
% Tamagawa University, Machida, JAPAN
%
%  INPUTS:
%   subDir: subject directory name
%   (ex. 'LHON1-TK-20121130-DWI')
%   option:  0: default (single masurement. analyzing 'dwi.nii.gz')
%            1: analyzing first diffusion measure 'dwi1st.nii.gz'
%            2: analyzing second diffusion measure 'dwi2nd.nii.gz'
%
%
% SO @ACH 

%% argument check
if notDefined('subDir')
    [basedir, subDir] = fileparts(pwd);
end

% if notDefined('option')
%     option = 1; % 
% end

%% Set the optimal parameter for SIEMENS scan at Tamagawa
dwParams = dtiInitParams;
dwParams.clobber=0;
% This flipping is specifically important for SIEMENS scans
dwParams.rotateBvecsWithCanXform = 1;
dwParams.rotateBvecsWithRx = 0;
% Phase encoding direction is A/P
dwParams.phaseEncodeDir = 2; %default 2
dwParams.flipLrApFlag=0; % default = 0

%% Define folder name for 1st and 2nd scans
dt6_base_names = {'dwi', 'dwi_1st', 'dwi_2nd', 'dwi_3rd','dwi_4th'};

subjectpath = fullfile(basedir, subDir);
cd(subjectpath);
t1File = dir(fullfile(subjectpath, '03T1*.nii'));
t1File = fullfile(subjectpath,t1File.name);
%%  mrAnatAverageAcpcNifti
% Make sure if Acpc alighnment was done
%
% if you do not finish it, mrAnatAverageAcpcNifti.m
% 
% This mrAnatAverageAcpcNifti requires spm8 (is not latest ver.)
%
%% Set xform to raw t1 File
ni = readFileNifti(t1File);
ni1 = niftiSetQto(ni,ni.sto_xyz);
writeFileNifti(ni1);

%% Selecting different file names between 1st and 2nd scans
% switch option
%     case 0,
        rawdtiFile = dir(fullfile(subjectpath, '03Myelin*.nii'));      
        rawdtiFile = fullfile(subjectpath, rawdtiFile.name);

        dwParams.bvecsFile = fullfile(subjectpath, 'dwi.bvec');
        dwParams.bvalsFile = fullfile(subjectpath, 'dwi.bval');
        dwParams.fitMethod = 'ls';
        dwParams.dt6BaseName= dt6_base_names{1};
        dwParams.outDir = fullfile(subjectpath, 'raw');
        if ~exist(dwParams.outDir,'dir');
            mkdir(dwParams.outDir)
        end
%     case 1,
%         rawdtiFile = fullfile(subjectpath, 'raw', 'dwi1st.nii.gz');
%         dwParams.bvecsFile = fullfile(subjectpath, 'raw', 'dwi1st.bvec');
%         dwParams.bvalsFile = fullfile(subjectpath, 'raw', 'dwi1st.bval');
%         dwParams.fitMethod = 'both';
%         dwParams.dt6BaseName= dt6_base_names{2};
%         dwParams.outDir = fullfile(subjectpath, 'raw');
%     case 2,
%         rawdtiFile = fullfile(subjectpath, 'raw', 'dwi2nd.nii.gz');
%         dwParams.bvecsFile = fullfile(subjectpath, 'raw', 'dwi2nd.bvec');
%         dwParams.bvalsFile = fullfile(subjectpath, 'raw', 'dwi2nd.bval');
%         dwParams.fitMethod = 'both';
%         dwParams.dt6BaseName= dt6_base_names{3};
%         dwParams.outDir = fullfile(subjectpath, 'raw');
%     case 3,
%         rawdtiFile = fullfile(subjectpath, 'raw', 'dwi3rd.nii.gz');
%         dwParams.bvecsFile = fullfile(subjectpath, 'raw', 'dwi3rd.bvec');
%         dwParams.bvalsFile = fullfile(subjectpath, 'raw', 'dwi3rd.bval');
%         dwParams.fitMethod = 'both';
%         dwParams.dt6BaseName= dt6_base_names{4};
%         dwParams.outDir = fullfile(subjectpath, 'raw');
%     case 4,
%         rawdtiFile = fullfile(subjectpath, 'raw', 'dwi4th.nii.gz');
%         dwParams.bvecsFile = fullfile(subjectpath, 'raw', 'dwi4th.bvec');
%         dwParams.bvalsFile = fullfile(subjectpath, 'raw', 'dwi4th.bval');
%         dwParams.fitMethod = 'both';
%         dwParams.dt6BaseName= dt6_base_names{5};
%         dwParams.outDir = fullfile(subjectpath, 'raw');
% end

%% Set rawdtiFile xform 
ni = readFileNifti(rawdtiFile);
ni = niftiSetQto(ni,ni.sto_xyz);
writeFileNifti(ni);

%% Run dtiInit
% Execute dtiInit
[dt6FileName, outBaseDir] = dtiInit(rawdtiFile, t1File, dwParams);

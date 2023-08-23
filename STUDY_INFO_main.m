clear all
clc

%% this is being run on you thinkpab windows 10 beast.

%%%%% are these new subjects or rerunning old? [0=new, 1=old]
det.neworold=1;
%%%%% Do you want to check ICA manually (0) or automatically (1) (based on SDs)
det.ICA= 0
%%%% Where the subjects' data directories are stored etc.
det.root = 'C:/levEEGanalysis';
det.rootstudy = 'C:/levEEGanalysis/main/';
det.rawdata = 'C:/levEEGanalysis/rawdata/';
det.rootstudyEX = 'D:/levEEGanalysis/main/';
det.behaviouralroot='C:/levEEGanalysis/data/';

% det.epochs={'mothon'};   %%% main epochs extracted
det.epochs={'response'};   %%% main epochs extracted
det.connames={'leftmoth','rightmoth'};  %%%% selected for separation - may have more than one of these!
det.connames2={'congcue','incongcue'};  %%%% selected for separation - may have more than one of these!
% det.epochlength=([-0.6       5.9]);  %%%moth on epochs
det.epochlength=([-1.5       0.2]); %%% response epochs
det.epochlength=([-2.1      4.2]); %%% trion epochs

det.e_list='main_eventcodes2.txt'; % event list
det.epoch_removal_diary = '_epochs_removed.txt';


det.eegcapfileMAT=('C:/Program Files/MATLAB/R2019b/toolbox/eeglab2019_1/plugins/dipfit/standard_BESA/standard_BESA.mat');
det.eegcapfileELP=('C:/Program Files/MATLAB/R2019b/toolbox/eeglab2019_1/plugins/dipfit/standard_BESA/standard-10-5-cap385.elp');
det.eegcapfileT1=( 'C:/Program Files/MATLAB/R2019b/toolbox/eeglab2019_1/plugins/dipfit/standard_BESA/avg152t1.mat');


%%%% list of subjects you want to analyse
det.subjects ={'jabi','xpbc','cocq','xswe','cder','vfrt','bgty','cxza','vcxs','bvcd','nbvf','mnbg','weds','erfd','rtgf','tyhg','yujh','uikj'}; 
%% %% particpants removed for poor data
% 'zaqw': PC didn't save any behavioural REMOVED
% nhyu: Got too many wrong, reported couldn't see them well. REMOVED
% qwsa: same as above bu not as bad - check out. REMOVED


% % Just some parameters for your filtering etc.
det.HP = 1 % highpass filter (stage2)
det.HP2=0.1  %  ERP filtering
det.LP = 40 % lowpass filter (stage2)
det.noise50=0
%%%% note, these will change depending on how you're analysing the datasets
%%%% later. 1hz is better if you're doing ICA to remove artifacts- but can
%%%% mess up ERP data (see stage 2 file). 
det.chnrm=[71 72] % channels to remove
det.baseline=[-100  -20]

% %%% first three dedone ICA
if det.neworold==0;
%%%%% this create new folders for new subjects 
for k=1:length(det.subjects)
    studyanalyse=fullfile(det.rootstudy);
    rawdat=fullfile(det.rawdata);
    rawdatafile=strcat([det.subjects{k} '.bdf']);
    cd (studyanalyse);
    mkdir (det.subjects{k});
    cd (rawdat);
    copyfile (rawdatafile, fullfile(det.rootstudy, det.subjects{k}));
end
else;
'skip new folders'
end;
   
% %%% for fieldtrip
% outputfolder=('C:/EEG_analysis/main_2/RESULTOUTPUT')
% inputfolder=('C:/EEG_analysis/main_2/FIELDTRIPgroup/combinedtrials')
% 
% 
% % %%%% this just puts blanks analysis notes in each folder. 
for k=1:length(det.subjects)

    cd (det.root);
    copyfile ('analysisnotes_blank.txt', fullfile(det.rootstudy, det.subjects{k}, 'analysisnotes_blank.txt')); 
    save detinfo det
    copyfile ('detinfo.mat', fullfile(det.rootstudy, det.subjects{k}, 'detinfo.mat')); 
end

% 
% 
% 
%  
cd (det.rootstudy)
% t = datetime('now')
% fileID = fopen('REFREF_notes.txt','a');
% fprintf(fileID, 'Lists all the faster output/n');
% fprintf(fileID, '%s/n/n',datestr(t));
% fileID2 = fopen('FASTER_notes.txt','a');
% fprintf(fileID2, 'Lists all the faster output/n');
% fprintf(fileID2, '%s/n/n',datestr(t));
% fileID3 = fopen('ICA_notes.txt','a');
% fprintf(fileID3, 'Lists all the ICA removals/n');
% fprintf(fileID3, '%s/n/n',datestr(t));

% % just change directory to the root. 


global det

% run runeeglab;
% close all;

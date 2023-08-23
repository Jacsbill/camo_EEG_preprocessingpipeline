% Input and output folder paths
filePathIn = det.rootstudy;
% create cell array of subject names / filenames
subjects = det.subjects;
outputdir=('fieldtrip_output_erp_mothside');
for s = 1:length(subjects);
    subject_analyse=fullfile(det.rootstudy,det.subjects{s});
     subject_analyseEX=fullfile(det.rootstudyEX,det.subjects{s});
    cd(subject_analyse);
    for ss=1:length(det.connames);
        
    % define the name of the data set to be loaded
     filename=strcat([det.subjects{s} '_0p1Hz_' det.connames{ss} '.set']);
     % load data
     EEG = pop_loadset(filename);
    % eeglab2fieldtrip conversion
    data = eeglab2fieldtrip( EEG, 'preprocessing', 'none'); % http://www.fieldtriptoolbox.org/getting_started/eeglab?s[]=eeglab2fieldtrip#converting_data_between_eeglab_and_fieldtrip
  
    % freganalysis for each individual participant/file
    
    cfg = [];
    cfg.channel   = {'all', '-EXG1', '-EXG2', '-EXG3', '-EXG4', '-EXG5', '-EXG6', '-EXG7', '-EXG8'}; % Define channels, in this case all channels minus the 8 additional biosemi channels (used for EOG, Mastoids, etc.)
    cfg.trials             = 'all';   
    cfg.keeptrials = 'no';   % mike cohen says you shouldn't do single trial baseline correction. 
    cfg.covariance         = 'no';  % or 'yes' (default = 'no')
    cfg.covariancewindow   = 'all'
    cfg.keeptrials         = 'yes'; 
    avgerp = ft_timelockanalysis(cfg, data);

  cd(subject_analyse);
     save output
%      
     outputFile = strcat([det.subjects{s} '0p1hz' det.connames{ss} '.mat'])
     outputFile2=fullfile(det.rootstudy,outputdir,outputFile);
     save(outputFile2,'avgerp');
     end
     end




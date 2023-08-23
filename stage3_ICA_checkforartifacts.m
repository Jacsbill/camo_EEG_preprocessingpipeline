


%%%%%%% Genrally run ICA and the
%%%%%%% check for things like eye blinks etc. 
%%%%%%% You can run ICA and removal automatically, or you can check
%%%%%%% manually. options 0 or 1 resepctively
%%%%%%% Runica option selected for ICA
%%%%%%%
%%%%%%% good to save data pre and post ICA removal (either manual or
%%%%%%% automatically). You can't put componants back in and it takes an
%%%%%%% age to run. 
%%%%%%%
%%%%%%%
%%%%%%%
%%%%%%%
%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n=1:length(det.subjects);
    subject=det.subjects{n}
    subject_analyse=fullfile(det.rootstudy,det.subjects{n});
%      [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
      EEG = pop_loadset('filename',strcat([det.subjects{n} '_import_rr_filt.set']),'filepath',subject_analyse);
        EEG = pop_runica(EEG, 'extended',1,'interupt','on');

%    
    % For the next bit go Tools -> Locate dipoles using dipfit2 -> Head model and settings, run those settings and use eegh to save the command that looks something like this:
    EEG = pop_dipfit_settings( EEG, 'hdmfile', det.eegcapfileMAT, 'coordformat', 'Spherical','mrifile',det.eegcapfileT1, 'chanfile', det.eegcapfileELP,'chansel',[1:EEG.nbchan]);
   
    
    % next fit the dipole model for each independant componant. 
     EEG = pop_dipfit_gridsearch(EEG, [1:EEG.nbchan] ,[-85:17:85] ,[-85:17:85] ,[0:17:85] ,0.4);
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET); 
    EEG = pop_saveset( EEG, 'filename',strcat([det.subjects{n} '_import_rr_filt_postICA_noremoved.set']),'filepath',subject_analyse);

        
end

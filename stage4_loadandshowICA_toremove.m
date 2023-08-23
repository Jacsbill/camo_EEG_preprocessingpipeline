

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
      EEG = pop_loadset('filename',strcat([det.subjects{n} '_import_rr_filt_postICA_noremoved.set']),'filepath',subject_analyse);
  %%%%% watch this https://www.youtube.com/watch?v=AKCK7DXa0gY&t=281s
        %%%%% the componants towards the end contribute much less to the
        %%%%% variance, so can be ignored a bitmre. Componants 1-20 need
        %%%%% checking. 
        pop_selectcomps(EEG, [1:70] );
        cd(subject_analyse);
        
         answer = inputdlg('Enter space separated componants to remove:',...
             'comps', [1 50])
         
    user_val = str2num(answer{1})
    saveit=strcat([det.subjects{n} '_compstoremove_1hzdata.mat'])
    save(saveit,'user_val')
    end   


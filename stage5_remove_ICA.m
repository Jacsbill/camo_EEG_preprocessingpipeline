%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%%%%%% After you have run the ICA and looked at the maps/ time courses put
%%%%%%% the componants you want to remove in here, will also save a record.
%%%%%%% 
%%%%%%%
%%%%%%%  . 
%%%%%%%
%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('C:\Program Files\MATLAB\R2018b\toolbox\FASTER')
cd(det.rootstudy) 
addpath(det.root)
fileID5 = fopen('finaltrialnotes.txt','a');
fprintf(fileID5, 'StudyINFOrun\n');
fprintf(fileID5, '%s\n\n',datestr(t));


for n=1:length(det.subjects);
    
    subject_analyse=fullfile(det.rootstudy,det.subjects{n});
    cd(subject_analyse)
    previous_removed_com=strcat([det.subjects{n} '_compstoremove_1hzdata.mat'])
    load(previous_removed_com)
    comp2rm=user_val
     %%%% keep some notes.
     subject = det.subjects{n}
     t = datetime('now');
     fprintf(fileID5, 'Componants removed \n');
     fprintf(fileID5, '%s\t',subject);
     fprintf(fileID5, '%s\n',datestr(t));
     fprintf(fileID5,'%s\n\n',num2str(comp2rm));
   
  
  
%      [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
      EEG = pop_loadset('filename',strcat([det.subjects{n} '_import_rr_filt_postICA_noremoved.set']),'filepath',subject_analyse);
      sw=size(EEG.icaweights)
      pop_selectcomps(EEG, [1:sw(1)] );
      EEG = pop_subcomp( EEG, comp2rm, 0);
      EEG.setname=strcat(([det.subjects{n} '_import_rr_filt_ICArm.set']),'filepath',subject_analyse);
      EEG = pop_saveset( EEG, 'filename',strcat([det.subjects{n} '_import_rr_filt_ICArm.set']),'filepath',subject_analyse);
 
   
    
end

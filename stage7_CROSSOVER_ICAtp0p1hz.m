
addpath('C:\Program Files\MATLAB\R2018b\toolbox\FASTER')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% This code attaches you 1hz ICA to your 0p1hzICA file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 addpath('C:\Program Files\MATLAB\R2018b\toolbox\eeglab14_1_2b\functions\adminfunc')
 
addpath (det.root)
for n=1:length(det.subjects);
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];  %%% CLEAR ALL EEGLAB DATASETS
    subject=det.subjects{n};
    subject_analyse=fullfile(det.rootstudy,det.subjects{n});
    subject_analyseEX=fullfile(det.rootstudyEX,det.subjects{n});
    epochinfo=fullfile(det.rootstudy, det.e_list);
    clear user_val
    cd(subject_analyse)
%     [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    EEG = pop_loadset('filename',strcat([det.subjects{n} '_import_rr_filt_postICA_noremoved.set']),'filepath',subject_analyse);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    EEG = pop_loadset('filename',strcat([det.subjects{n} '_import_rr_filt2.set']),'filepath',subject_analyse);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    EEG = eeg_checkset( EEG );
    EEG = pop_editset(EEG, 'icachansind', 'ALLEEG(1).icachansind', 'icaweights', 'ALLEEG(1).icaweights', 'icasphere', 'ALLEEG(1).icasphere');
%     [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',strcat([det.subjects{n} '_import_rr_filt2_ICA.set']),'filepath',subject_analyse);
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    EEG = pop_loadset('filename',strcat([det.subjects{n} '_import_rr_filt2_ICA.set']),'filepath',subject_analyse);
%     [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    EEG = eeg_checkset( EEG );
    pop_selectcomps(EEG, [1:30] );
%     [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    fn=([det.subjects{n} '_compstoremove_1hzdata.mat']);
    load(fn);
   
      EEG = pop_subcomp( EEG, user_val, 0);
      EEG.setname=strcat(([det.subjects{n} '_import_rr_filt2_ICArm.set']),'filepath',subject_analyse);
      EEG = pop_saveset( EEG, 'filename',strcat([det.subjects{n} '_import_rr_filt2_ICArm.set']),'filepath',subject_analyse);
 
    
        end;



% %%%% more conditons
% %         EEG = pop_loadset('filename',strcat([det.subjects{n} '_import_rr_filt_elist_' det.epochs{nn} 'FASTER_REMOVED.set']),'filepath',subject_analyse);
% %         [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

% 
%     for nn=1:length(det.epochs);
%         
%         [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
%         EEG = pop_loadset('filename',strcat([det.subjects{n} '_import_rr_filt_elist.set']),'filepath',subject_analyse);
%         [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
%         EEG = eeg_checkset( EEG );
%         epsel=(det.epochs{nn})
%          EEG = pop_epoch( EEG, { epsel }, det.epochlength, 'newname',  strcat([det.subjects{n} '_import_rr_filt_elist.set']), 'epochinfo', 'yes');
%        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
%         EEG = eeg_checkset( EEG );
%         EEG = pop_rmbase( EEG, [-100  -20]);
%         [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 
%         EEG = eeg_checkset( EEG );
%         [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',strcat([det.subjects{n} '_import_rr_filt_elist_' det.epochs{nn} '.set']),'gui','off'); 
%         EEG = pop_saveset( EEG, 'filename', strcat([det.subjects{n} '_import_rr_filt_elist_' det.epochs{nn} '.set']),'filepath',subject_analyse);
%         [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
%         eeglab redraw;
%   
%         end;
% 
% end;
% 
% for n=1:length(det.subjects);
%     subject=det.subjects{n}
%     subject_analyse=fullfile(det.rootstudy,det.subjects{n});
%     cd (det.root);
%     [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
%     for nn=1:length(det.epochs);
%         epsel=(det.epochs{nn})
%         epochdiary=fullfile(det.rootstudy,det.subjects{n},strcat(epsel,det.epoch_removal_diary));
%         diary (epochdiary)
%         
%      
%         EEG = pop_loadset('filename',strcat([det.subjects{n} '_import_rr_filt_elist_' det.epochs{nn} '.set']),'filepath',subject_analyse);
%         [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
%         EEG = eeg_checkset( EEG );
%         cfg=[];
%         cfg.datachan=1:64;
%         [EEG,trials2remove,comps2remove]=eegF_FASTER(cfg,EEG)
%         [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',strcat([det.subjects{n} '_import_rr_filt_elist_' det.epochs{nn} 'FASTER.set']),'gui','off'); 
%          EEG = pop_saveset( EEG, 'filename', strcat([det.subjects{n} '_import_rr_filt_elist_' det.epochs{nn} 'FASTER.set']),'filepath',subject_analyse);
%          
%          EEG = pop_loadset('filename',strcat([det.subjects{n} '_import_rr_filt_elist_' det.epochs{nn} 'FASTER.set']),'filepath',subject_analyse);
%         [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
%         [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
%         EEG = pop_loadset('filename',strcat([det.subjects{n} '_import_rr_filt_elist_' det.epochs{nn} 'FASTER.set']),'filepath',subject_analyse);
%         [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
%         EEG = eeg_checkset( EEG );
%         pop_eegplot( EEG, 1, 1, 1);
%         EEG = pop_rejepoch( EEG, [trials2remove] ,0);
%         [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',strcat([det.subjects{n} '_import_rr_filt_elist_' det.epochs{nn} 'FASTER_REMOVED.set']),'gui','off'); 
%         EEG = eeg_checkset( EEG );
%         EEG = pop_saveset( EEG, 'filename',strcat([det.subjects{n} '_import_rr_filt_elist_' det.epochs{nn} 'FASTER_REMOVED.set']),'filepath',subject_analyse);
%         [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
% %%%% more conditons
% %         EEG = pop_loadset('filename',strcat([det.subjects{n} '_import_rr_filt_elist_' det.epochs{nn} 'FASTER_REMOVED.set']),'filepath',subject_analyse);
% %         [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
% %          EEG = pop_selectevent( EEG, 'type',{'target_present'},'deleteevents','off','deleteepochs','on','invertepochs','on');
% %         [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'setname',strcat([det.subjects{n} '_import_rr_filt_elist_' det.epochs{nn}  'FASTER_REMOVED_TGabs.set']),'gui','off'); 
% %         EEG = pop_saveset( EEG, 'filename',strcat([det.subjects{n} '_import_rr_filt_elist_' det.epochs{nn}  'FASTER_REMOVED_TGabs.set']),'filepath',subject_analyse);
% % 
% %          EEG = pop_loadset('filename',strcat([det.subjects{n} '_import_rr_filt_elist_' det.epochs{nn} 'FASTER_REMOVED.set']),'filepath',subject_analyse);
% %         [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
% %          EEG = pop_selectevent( EEG, 'type',{'target_present'},'deleteevents','off','deleteepochs','on','invertepochs','off');
% %         [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'setname',strcat([det.subjects{n} '_import_rr_filt_elist_' det.epochs{nn}  'FASTER_REMOVED_TGprs.set']),'gui','off'); 
% %         EEG = pop_saveset( EEG, 'filename',strcat([det.subjects{n} '_import_rr_filt_elist_' det.epochs{nn}  'FASTER_REMOVED_TGprs.set']),'filepath',subject_analyse);
% 
%             
%         EEG = eeg_checkset( EEG );
%         eeglab redraw;
%         diary off
%         eeglab redraw;
%         end;
% 
% end
% 
% 

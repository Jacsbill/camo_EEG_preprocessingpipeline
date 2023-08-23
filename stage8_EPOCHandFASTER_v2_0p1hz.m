

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% This code attaches your condition list to the main file and then
%%%%%%% creates seperate epochs. 
%%%%%%% Following this procedure it uses the FASTER toolbox to identify bad
%%%%%%% epochs for each of the epoched files. It doesn't delete them at
%%%%%%% *_FASTER
%%%%%%% this stage. 
%%%%%%% Thanks to Matt Craddock for the faster code.
%%%%%%% This script creates a second file which does have bad epochs
%%%%%%% deleted. *_FASTER REMOVED
%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath(det.root)
for n=1:length(det.subjects);
      STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];  %%% CLEAR ALL EEGLAB DATASETS
 
    subject=det.subjects{n};
    subject_analyse=fullfile(det.rootstudy,det.subjects{n});
    subject_analyseEX=fullfile(det.rootstudyEX,det.subjects{n});
    addpath(det.rootstudy);
    
    fileID2 = fopen('FASTER_notes_filt2.txt','a');
    epochinfo=fullfile(det.rootstudy, det.e_list);
    cd(subject_analyse)
   
%     [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
     EEG = pop_loadset('filename',strcat([det.subjects{n} '_import_rr_filt2_ICArm.set']),'filepath',subject_analyse);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 ); EEG = eeg_checkset( EEG );
    eeglab redraw;
    EEG = eeg_checkset( EEG );
    
    %%% load the study file and attaceh a list to it. 
    
    EEG  = pop_editeventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99}, 'BoundaryString', { 'boundary' }, 'List',epochinfo, 'SendEL2', 'EEG', 'UpdateEEG', 'codelabel', 'Warning', 'off' ); % GUI: 23-Nov-2017 17:29:32
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'setname',strcat([det.subjects{n} '_import_rr_filt2_elist.set']),'gui','off'); 
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',strcat([det.subjects{n} '_import_rr_filt2_ICArm_elist.set']),'filepath',subject_analyse);
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    %         
    
    %%% then epoch the study file
    
%         [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
        EEG = pop_loadset('filename',strcat([det.subjects{n} '_import_rr_filt2_ICArm_elist.set']),'filepath',subject_analyse);
        [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
        EEG = pop_epoch( EEG, [ det.epochs], det.epochlength, 'newname',  strcat([det.subjects{n} '_import_rr_filt2_ICArm_elist.set']), 'epochinfo', 'yes');
           EEG = pop_saveset( EEG, 'filename', strcat([det.subjects{n} 'view.set']),'filepath',subject_analyse);
    
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
        EEG = eeg_checkset( EEG );
        
        %%%% make sure you sync to a baseline. 
        EEG = pop_rmbase( EEG, det.baseline);
         
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 
        EEG = eeg_checkset( EEG );
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',strcat([det.subjects{n} '_import_rr_filt2_elist_epoched.set']),'gui','off'); 
        EEG = pop_saveset( EEG, 'filename', strcat([det.subjects{n} '_import_rr_filt2_elist_epoched.set']),'filepath',subject_analyse);
%         [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
        eeglab redraw;
        
        %%%% being lazy, open a diary to save removed trials
        epochdiary=fullfile(det.rootstudy,det.subjects{n},det.epoch_removal_diary);
        diary (epochdiary)
        EEG = pop_loadset('filename',strcat([det.subjects{n} '_import_rr_filt2_elist_epoched.set']),'filepath',subject_analyse);
        [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
        EEG = eeg_checkset( EEG );
        cfg=[];
        cfg.datachan=1:64;
        
        %%% lower = more removed
        cfg.thresh=[3 3 0 3 3 12]
        trh=cfg.thresh
        %%%%% run facter to remove trials
        [EEG,trials2remove,comps2remove,gen_bad_chans]=eegF_FASTER(cfg,EEG)
    
          save Faster_BCfilt2 gen_bad_chans
          save Faster_BTfilt2 trials2remove
          save Faster_threshfilt2 trh
          cd ..
          t = datetime('now')
          fprintf(fileID2, '%s\t',subject);
          fprintf(fileID2, '%s\n',datestr(t));
          fprintf(fileID2, 'Trials removed\n');
          fprintf(fileID2,'%s\n',num2str(trials2remove));
          fprintf(fileID2, 'Channels interpolated\n');
          fprintf(fileID2,'%s\n\n',num2str(transpose(gen_bad_chans)));
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',strcat([det.subjects{n} '_import_rr_filt2_ICArm_elist_FASTER.set']),'gui','off'); 
        EEG = pop_saveset( EEG, 'filename', strcat([det.subjects{n} '_import_rr_filt2_ICArm_elist_FASTER.set']),'filepath',subject_analyse);
        
        %%%%% save the file without removing trials
        EEG = pop_loadset('filename',strcat([det.subjects{n} '_import_rr_filt2_ICArm_elist_FASTER.set']),'filepath',subject_analyse);
        [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
        EEG = eeg_checkset( EEG );
        pop_eegplot( EEG, 1, 1, 1);
        set(gcf, 'Name', subject)
        EEG = pop_rejepoch( EEG, [trials2remove] ,0);
        
        %%%%% remove the trials and save it again, worth keeping both and
        %%%%% then check over the data and decide which one to use for next
        %%%%% stage. i.e. you can always change fasters decisions if it's
        %%%%% removed lots unesserily. 
        
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',strcat([det.subjects{n} '__import_rr_filt2_ICArm_elist_FASTER_REMOVED.set']),'gui','off'); 
        EEG = eeg_checkset( EEG );
        EEG = pop_saveset( EEG, 'filename',strcat([det.subjects{n} '__import_rr_filt2_ICArm_elist_FASTER_REMOVED.set']),'filepath',subject_analyse);
        [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
         EEG = eeg_checkset( EEG );
        eeglab redraw;
        diary off
        eeglab redraw;
        end;



% %%%% more conditons
% %         EEG = pop_loadset('filename',strcat([det.subjects{n} '_import_rr_filt2_elist_' det.epochs{nn} 'FASTER_REMOVED.set']),'filepath',subject_analyse);
% %         [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

% 
%     for nn=1:length(det.epochs);
%         
%         [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
%         EEG = pop_loadset('filename',strcat([det.subjects{n} '_import_rr_filt2_elist.set']),'filepath',subject_analyse);
%         [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
%         EEG = eeg_checkset( EEG );
%         epsel=(det.epochs{nn})
%          EEG = pop_epoch( EEG, { epsel }, det.epochlength, 'newname',  strcat([det.subjects{n} '_import_rr_filt2_elist.set']), 'epochinfo', 'yes');
%        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
%         EEG = eeg_checkset( EEG );
%         EEG = pop_rmbase( EEG, [-100  -20]);
%         [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 
%         EEG = eeg_checkset( EEG );
%         [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',strcat([det.subjects{n} '_import_rr_filt2_elist_' det.epochs{nn} '.set']),'gui','off'); 
%         EEG = pop_saveset( EEG, 'filename', strcat([det.subjects{n} '_import_rr_filt2_elist_' det.epochs{nn} '.set']),'filepath',subject_analyse);
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
%         EEG = pop_loadset('filename',strcat([det.subjects{n} '_import_rr_filt2_elist_' det.epochs{nn} '.set']),'filepath',subject_analyse);
%         [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
%         EEG = eeg_checkset( EEG );
%         cfg=[];
%         cfg.datachan=1:64;
%         [EEG,trials2remove,comps2remove]=eegF_FASTER(cfg,EEG)
%         [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',strcat([det.subjects{n} '_import_rr_filt2_elist_' det.epochs{nn} 'FASTER.set']),'gui','off'); 
%          EEG = pop_saveset( EEG, 'filename', strcat([det.subjects{n} '_import_rr_filt2_elist_' det.epochs{nn} 'FASTER.set']),'filepath',subject_analyse);
%          
%          EEG = pop_loadset('filename',strcat([det.subjects{n} '_import_rr_filt2_elist_' det.epochs{nn} 'FASTER.set']),'filepath',subject_analyse);
%         [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
%         [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
%         EEG = pop_loadset('filename',strcat([det.subjects{n} '_import_rr_filt2_elist_' det.epochs{nn} 'FASTER.set']),'filepath',subject_analyse);
%         [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
%         EEG = eeg_checkset( EEG );
%         pop_eegplot( EEG, 1, 1, 1);
%         EEG = pop_rejepoch( EEG, [trials2remove] ,0);
%         [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',strcat([det.subjects{n} '_import_rr_filt2_elist_' det.epochs{nn} 'FASTER_REMOVED.set']),'gui','off'); 
%         EEG = eeg_checkset( EEG );
%         EEG = pop_saveset( EEG, 'filename',strcat([det.subjects{n} '_import_rr_filt2_elist_' det.epochs{nn} 'FASTER_REMOVED.set']),'filepath',subject_analyse);
%         [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
% %%%% more conditons
% %         EEG = pop_loadset('filename',strcat([det.subjects{n} '_import_rr_filt2_elist_' det.epochs{nn} 'FASTER_REMOVED.set']),'filepath',subject_analyse);
% %         [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
% %          EEG = pop_selectevent( EEG, 'type',{'target_present'},'deleteevents','off','deleteepochs','on','invertepochs','on');
% %         [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'setname',strcat([det.subjects{n} '_import_rr_filt2_elist_' det.epochs{nn}  'FASTER_REMOVED_TGabs.set']),'gui','off'); 
% %         EEG = pop_saveset( EEG, 'filename',strcat([det.subjects{n} '_import_rr_filt2_elist_' det.epochs{nn}  'FASTER_REMOVED_TGabs.set']),'filepath',subject_analyse);
% % 
% %          EEG = pop_loadset('filename',strcat([det.subjects{n} '_import_rr_filt2_elist_' det.epochs{nn} 'FASTER_REMOVED.set']),'filepath',subject_analyse);
% %         [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
% %          EEG = pop_selectevent( EEG, 'type',{'target_present'},'deleteevents','off','deleteepochs','on','invertepochs','off');
% %         [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'setname',strcat([det.subjects{n} '_import_rr_filt2_elist_' det.epochs{nn}  'FASTER_REMOVED_TGprs.set']),'gui','off'); 
% %         EEG = pop_saveset( EEG, 'filename',strcat([det.subjects{n} '_import_rr_filt2_elist_' det.epochs{nn}  'FASTER_REMOVED_TGprs.set']),'filepath',subject_analyse);
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

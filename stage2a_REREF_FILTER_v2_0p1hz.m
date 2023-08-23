
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% this bit of code re-references the data, to the average of all
%%%%%%% channels (asside from 71 72, these are the EXG channels we don't
%%%%%%% use. After rereferencing, it also deletes these channels and
%%%%%%% resaves the data. you should have a file with 70 channels in after
%%%%%%% this point (or less if you manually removed some). File name will be appended _rr
%%%%%%% It then filters the data using det.HP and det.LP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% after this stage it's probably a good idea to plot your data and
%%%%%%% have a scroll through again, make sure everything is looking
%%%%%%% okay-ish. Following epoching you'll have another clean of the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Note, if you're doing ICA for artifact removal best to use 1Hz
%%%%%%% highpass and then use the decomposition parameters from this analysis and put them
%%%%%%% in a 0.1hz filtered data set after you've done the ICA. 
%%%%%%% 1Hz can mess up your ERP data, 0.1Hz better for ERP analysis.
%%%%%%% There are reports that 1-Hz high-pass filter attenuates (or even 'distorts') low-frequency, 
%%%%%%% so-called 'late slow waves' of event-related potential family, such as N400 or P600 
%%%%%%%(these names are paradigm dependent, of course). To avoid this problem, one can calculate 
%%%%%%% ICA weight matrix and sphereing matrix with 1-Hz high-passed data, then apply it to 0.1-Hz
%%%%%%% high-passed data. This ICA matrices transfer can be done through EEGLAB GUI 'Edit' -> 
%%%%%%% 'Dataset info'. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n=1:length(det.subjects);
    subject=det.subjects{n}
    subject_analyse=fullfile(det.rootstudy,det.subjects{n});
%     subject_analyseEX= fullfile(det.externaldrive,det.subjects{n});

    cd(subject_analyse)
%     [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
      EEG = pop_loadset('filename',strcat([det.subjects{n} '_import.set']),'filepath',subject_analyse);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 ); EEG = eeg_checkset( EEG );
        eeglab redraw;
        
        
     load badchan.mat
     
     if length(crpch)>0;
         EEG = pop_interp(EEG, [crpch], 'spherical');
     else
         fprintf('ok')
     end

     chm2=[det.chnrm crpch]
     
     %%%% keep some notes.
     t = datetime('now');
     fprintf(fileID, 'Lists channels data were referenced to \n\n');
     fprintf(fileID, '%s\t',subject);
     fprintf(fileID, '%s\n',datestr(t));
     fprintf(fileID,'%f %f\n',chm2);
     EEG = pop_reref( EEG, [],'exclude',chm2);
     saveit=strcat([det.subjects{n} '_removedchansatrerefstage2a.mat'])
     save(saveit,'chm2')
     [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','rereffed','gui','off'); 
     EEG = eeg_checkset( EEG );
     eeglab redraw;
     EEG = pop_select( EEG,'nochannel',{'EXG7' 'EXG8'});
     [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 
     EEG = eeg_checkset( EEG );
     EEG = pop_saveset( EEG, 'filename',strcat([det.subjects{n} '_import_rr2.set']),'filepath',subject_analyse);
%      [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
     EEG = pop_loadset('filename',strcat([det.subjects{n} '_import_rr2.set']),'filepath',subject_analyse);
     [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
     EEG = pop_firws(EEG, 'fcutoff', det.HP2, 'ftype', 'highpass', 'wtype', 'kaiser', 'warg', 5.65326, 'forder', 1856, 'minphase', 0);
     [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'setname',strcat([det.subjects{n} '_import_rr_filt.set']),'gui','off'); 
     EEG = pop_firws(EEG, 'fcutoff', det.LP, 'ftype', 'lowpass', 'wtype', 'kaiser', 'warg', 5.65326, 'forder', 372, 'minphase', 0);
     [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'setname',strcat([det.subjects{n} '_import_rr_filt.set']),'gui','off'); 
     EEG = eeg_checkset( EEG );
     EEG = pop_saveset( EEG, 'filename',strcat([det.subjects{n} '_import_rr_filt2.set']),'filepath',subject_analyse);
     EEG = pop_loadset('filename',strcat([det.subjects{n} '_import_rr_filt2.set']),'filepath',subject_analyse);
     [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 ); 
     EEG = eeg_checkset( EEG );
     
    eeglab redraw;


end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%  this bit of code searches through all the foldered for a BDF file
%%%%%%%  (bio semi raw data file and then imports them into EEGlab, adds
%%%%%%%  the channel locations and saves the file as an EEGlab data file. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Once you've run this file it's good to check through the data by
%%%%%%% eye for MAJOR misgivings, smaller things can be removed
%%%%%%% automatically. Mainly the check is for bad channels, remove them
%%%%%%% rereference and do all you ICA and then reintroduce them with sphreical interpolation. 
%%%%%%% Plot should come up at the
%%%%%%% end but if you're doing loads comment this out and you can do it manually after a batch run. When you load
%%%%%%% plot, do DC offset check (else you can't always see all the
%%%%%%% elctrodes.
%%%%%%% Files will be saved as _import.set
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% save badchannels in subject folder e.g. 
%%%%%%%% crpch=[56];  save badchan crcph

for n=1:length(det.subjects);
    subject=det.subjects{n}
    subject_analyse=fullfile(det.rootstudy,det.subjects{n});
    matlabcap=fullfile(det.eegcapfileELP);
    cd (subject_analyse)
    BioSemiFiles = dir ('*.bdf');
    filename = BioSemiFiles.name
    EEG = pop_biosig(filename);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',strcat([det.subjects{n} '_import']),'gui','off'); 
    EEG=pop_chanedit(EEG, 'lookup',matlabcap);
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    EEG = eeg_checkset( EEG );
    EEG = pop_resample( EEG, 512);
    EEG = pop_saveset( EEG, 'filename',strcat([det.subjects{n} '_import']),'filepath',subject_analyse);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 ); 
% % %   comment this out for when you're running tonnes
    EEG = eeg_checkset( EEG );
    pop_eegplot( EEG, 1, 1, 1);
    set(gcf, 'Name', subject)
    eeglab redraw;
% % % comment this out for when you're running tonnes
end;
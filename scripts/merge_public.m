% ------------------------------------------------
raw_eeg_dir = '...'; % path to your folder with the raw datasets
analyzed_eeg_dir = '...'; % path to your folder with the analyzed datasets
log_dir = '...'; % path to your folder with log files

all_subj = dir(fullfile(analyzed_eeg_dir, 's*'));
all_subjects = {all_subj.name};
%exclude_subjects = {'...'}; % here are the subject ID's that you want to
%exclude from the analysis
%remove_idx = ismember(all_subjects, exclude_subjects);
subjects = all_subjects; %all_subjects(~remove_idx)

num_runs = 3;

for isub = 1:length(subjects)
    subj_start = tic;
    subj_str = subjects{isub};
    cur_subj = subj_str;
    subj_anal_dir = fullfile(analyzed_eeg_dir, subj_str);
    
    set_str_out = 'merge';
    
    % print out info to a diary file
    diaryname = fullfile(log_dir, sprintf('%s_diaryfile-%s_%s.txt', subj_str, set_str_out, date));  
    diary(diaryname);

    if ~isdir(subj_anal_dir)
        mkdir(subj_anal_dir);
    end
    
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
   
   runs_to_merge = [1 2 3]; 
   for iset = 1:num_runs % loop across runs
        filename = fullfile(analyzed_eeg_dir, subj_str, sprintf('%s_run%s_elecloc_hpflt01Hz_crazy_elist_bins_rerefMeanMast_ica_rejICs_blinkdet_rename.set', subj_str, num2str(iset))); 
        if ~exist(filename, 'file')
            fprintf('%s does not exist - skipping\n', filename) 
            continue;
        end
        
        % Load datasets
        EEG = pop_loadset('filename', sprintf('%s_run%s_elecloc_hpflt01Hz_crazy_elist_bins_rerefMeanMast_ica_rejICs_blinkdet_rename.set', subj_str, num2str(iset)), 'filepath', subj_anal_dir);
        [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
        EEG = eeg_checkset( EEG );
        eeglab redraw;
    end
    
    % Merge datasets
    mergedEEG = pop_mergeset( ALLEEG, runs_to_merge, 0);
    %Save dataset:
    EEG = pop_saveset(mergedEEG, 'filename',sprintf('%s_elecloc_hpflt01Hz_crazy_elist_bins_rerefMeanMast_ica_rejICs_blinkdet_rename_%s.set', subj_str, set_str_out),'filepath',subj_anal_dir);

    % be super cautious and clear out the sets between subjects
    clear ALLEEG EEG mergedEEG
    
    subj_end = toc(subj_start);
    fprintf('\nThat took %d minutes and %f seconds.\n',floor(subj_end/60),rem(subj_end,60))
    diary off;
    
end


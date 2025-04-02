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



for isub = 1:length(subjects)
    subj_start = tic;
    subj_str = subjects{isub};
    cur_subj = subj_str;
    subj_anal_dir = fullfile(analyzed_eeg_dir, subj_str);
    
    set_str_out = 'best';
    
    % print out info to a diary file
    diaryname = fullfile(log_dir, sprintf('%s_diaryfile-%s_%s.txt', subj_str, set_str_out, date));  
    diary(diaryname);

    if ~isdir(subj_anal_dir)
        mkdir(subj_anal_dir);
    end
    
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    
   % for iset = 1:num_runs % loop across blocks
   filename = fullfile(analyzed_eeg_dir, subj_str, sprintf('%s_elecloc_hpflt01Hz_crazy_elist_bins_rerefMeanMast_ica_rejICs_blinkdet_rename_merge_elist_bins_epoch_rejBoundary_artMW.set', subj_str)); 
   if ~exist(filename, 'file')
      fprintf('%s does not exist - skipping\n', filename) 
      continue;
   end
        
   
   EEG = pop_loadset('filename', sprintf('%s_elecloc_hpflt01Hz_crazy_elist_bins_rerefMeanMast_ica_rejICs_blinkdet_rename_merge_elist_bins_epoch_rejBoundary_artMW.set', subj_str), 'filepath', subj_anal_dir);
   
   % Exclude epochs marked during artifact detection
   BEST = pop_extractbest( EEG , 'Bins', [ 1:6], 'Criterion', 'good', 'ExcludeBoundary', 'on' );

   % save BEST file
   BEST = pop_savemybest(BEST, 'bestname', 'BEST', 'filename', sprintf('%s_BEST_excludeepochs.best', subj_str), 'filepath', subj_anal_dir, 'Warning', 'on');
   eeglab redraw;
   %end

   subj_end = toc(subj_start);
   fprintf('\nThat took %d minutes and %f seconds.\n',floor(subj_end/60),rem(subj_end,60))
   diary off;
    
end

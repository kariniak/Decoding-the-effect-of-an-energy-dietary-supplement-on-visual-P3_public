% ------------------------------------------------
raw_eeg_dir = '...'; % path to your folder with the raw datasets
analyzed_eeg_dir = '...'; % path to your folder with the analyzed datasets
log_dir = '...'; % path to your folder with log files

all_subj = dir(fullfile(analyzed_eeg_dir, 's*'));
all_subjects = {all_subj.name};


%N=24 - at least 40 trials
subjects = {'s5', 's7', 's8', 's9', 's10', 's11', 's12', 's18', 's19', 's23', 's27', 's28', 's29', 's30', 's32', 's33', 's34', 's35', 's37', 's38', 's40', 's42', 's44', 's46'};



for isub = 1:length(subjects)
    subj_start = tic;
    subj_str = subjects{isub};
    
    cur_subj = subj_str; 
    subj_anal_dir = fullfile(analyzed_eeg_dir, subj_str);
    


    if ~isdir(subj_anal_dir)
        mkdir(subj_anal_dir);
    end
    
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    

   % Load BEST file
   BEST = pop_loadbest( 'filename', sprintf('%s_BEST_excludeepochs.best', subj_str), 'filepath', subj_anal_dir);
   
   % Decode
   MVPC = pop_decoding( BEST , 'Channels', [ 1:30], 'classcoding', 'OneVsAll', 'Classes', [ 2:2:6], 'Decode_Every_Npoint', [ 2], 'DecodeTimes', [ -195.312 796.875], 'EqualizeTrials', 'floor', 'FloorValue', [ 10], 'Method', 'SVM', 'nCrossblocks', [ 4], 'nIter', [ 100], 'ParCompute', 'on' );
   eeglab redraw;
   
   % Save decoded file
   MVPC = pop_savemymvpc(MVPC, 'mvpcname', sprintf('%s_MVPC_f4_t10_excludeepochs', subj_str), 'filename', sprintf('%s_MVPC_f4_t10_excludeepochs.mvpc', subj_str), 'filepath', subj_anal_dir, 'Warning', 'on');

   subj_end = toc(subj_start);
   fprintf('\nThat took %d minutes and %f seconds.\n',floor(subj_end/60),rem(subj_end,60))
   diary off;
    
end

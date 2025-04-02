# Decoding-the-effect-of-an-energy-dietary-supplement-on-visual-P3_public
Decoding event-related potentials: single-dose energy dietary supplement acts on earlier brain processes than we thought
This project describes an experimental work using machine learning (ML) as a “decoding for interpretation” to understand the brain’s physiology better. Multivariate pattern analysis (MVPA) was used to decode the patterns of event-related potentials (ERPs, brain responses to stimuli) in a visual oddball task.

You will need Matlab with two toolboxes for EEG analysis: EEGLAB (https://sccn.ucsd.edu/eeglab/) and ERPLAB (https://erpinfo.org/erplab). For ERPLAB, The Matlab Signal Processing Toolbox is required. For decoding, you will need "Multivariate Pattern Classification Tool", implemented in the ERPLAB since v10. Decoding tutorial is here: https://github.com/ucdavis/erplab/wiki/Decoding-Tutorial.

Preprocessing for decoding
1. Take 'sID_runNUMBER_elecloc_hpflt01Hz_crazy_elist_bins_rerefMeanMast_ica_rejICs_blinkdet.set' files (where ID is the participant's ID, and NUMBER is the run number (1 to 3). These are initially pre-processed ERP datasets, described in: Maciejewska K, Grabowska K. Acute effect of energy boost dietary supplement on P3 waveform: double blind, placebo controlled study. Acta Neurobiol Exp (Wars). 2020;80(4):411-423. PMID: 33350994.
2. Rename trial types for each run separately (because we have to have all runs in one file, but all trial types are B1 and B2 in all runs): Edit -> Select epochs and events -> choose 'type' -> Rename selected event type as type: new_name -> Uncheck 'remove epochs not referenced by selected event'. Remember that new names have to be numbers, so: 10 from run1 -> 101, 20 from run1 -> 201, 10 from run2 -> 102, 20 from run2 -> 202, 10 from run3 -> 103, 20 from run3 -> 203. SCRIPT: rename_public.m
3. Merge all runs: Edit -> Append datasets. SCRIPT: merge_public.m
4. Create EVENTLIST. SCRIPT: 'create_eventlist_public.m'.
5. Create bins using BINLISTER. BDF file: 'bins_decoding.txt'. SCRIPT: 'create_bins.m'.
6. Create epochs. SCRIPT: 'ERPepoch.m'.
7. Reject epochs that contain boundaries (i.e. trial '-99') because there was an error during creating BEST where there were more than one -99 event in the epoch. SCRIPT: 'rej_boundaries.m'.
8. Identify and remove artifacts in ERPs using the moving window tool. SCRIPT: 'MW.m'.

Now ready for DECODING
1. Create BEST files excluding epochs marked during artifact detection. SCRIPT: 'createBEST_exclude.m'. OUTPUT: 's%_BEST_excludeepochs.best'
2. Decode.
 2.1. Decode datasets with excluded trials (N=31). For all: 3 folds, floor=10 trials per class, SVM, one vs. all, every 2nd point: 
    (1) run1 vs. run2 vs. run3, SCRIPT: 'decode_folds3_trials10_N31_exclude.m'; 
 2.2. Decode datasets with excluded trials (N=24). For all: 4 folds, floor=10 trials per class, SVM, one vs. all, every 2nd point: 
    (1) run1 vs. run2 vs. run3, SCRIPT: 'decode_folds4_trials10_N24_exclude.m'; 
 2.3. Decode datasets with excluded (N=24). For all: 3 folds, floor=13 trials per class, SVM, one vs. all, every 2nd point: 
    (1) run1 vs. run2 vs. run3, SCRIPT: 'decode_folds3_trials13_N24_exclude.m'; 
4. Plot decoding results.
5. Plot confusion matrix.

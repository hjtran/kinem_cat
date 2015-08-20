# kinem_cat
MATLAB program to analyze a kinematic cat recording.

# Method
Recording is first smoothed using a median filter of arbitrary size window. Data is then partitioned
into rounds which are then partitioned into steps which are then again partitioned into stance
and swing cycles. The desired Nth step is then taken from every round and normalized. The normalized
values of the desired kinematic property are then binned into any desired number of bins and output
into a csv (although actually with a txt file extension) which can then be processed in Excel
or any other spreadsheet processor. Program can be run with a GUI or CL.

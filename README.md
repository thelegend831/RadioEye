# RadioEye
A user interface for device data calibration, classification algorithm development with emulation and real-time monitored ablation for cardiac arrhythmia treatment.

## Usage
Download the package file *RadioEye.mlappinstall*, install it in a MATLAB environment.

## Workflow
### Calibrate
The vector-network-analyzer (VNA) provides a driver that help you collect electrical response data from the detection/ablation catheter in a .csv file. Use 'calibrate' mode to label the data. Labels will be saved in a .mat file. Unfinished labeling could be resumed by loading the .mat file.

### Emulate
To develop effective response data classification algorithm, an emulation mode could be used to characterize the algorithm performance. Load the raw .csv data and corresponding .mat label data (could omit if only want to test on raw), select the classifier and run. Auto-classificaton results and expert labeling would be displayed side-by-side for comparison.

### Ablate
This mode requires actually connected to the ablation device and the VNA component running in a Windows environment. Establish the connection and start run, real-time monitoring of the ablation would be displayed.

## Further Development
There are a few components that could be extended as the ablation sensor and data gets more complicated.

* Multiple sensor calibration and selection
* Finer grained ablation levels (color coded) from experimental data
* Sophisticated classifier algorithm

## Contact
Xiaoyang Liu, Johns Hopkins University, xliu68@jhu.edu
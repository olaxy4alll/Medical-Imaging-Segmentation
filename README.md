### Auto_LV_endocardium_segmentation (MSCV1 project work)

The goal of this project work was to develop an automatic system for Left Ventricles segmentation from a cardiac MRI ( in NIFTI ) in order t estimate the Cavity volume and mass of the LV.

* The method been adopted involves k-means with graph search algorithm and Deep Learning.
* The implementation of each method will be described and both methods will be unified in a GUI tool for better usability. The tool is a
  user interface application which developed in Python and wrapped under MATLAB to give better access for further development.
  The objective of the tool is to segment the LV during diastole and systole (only the endocardium) in MRI images and calculate
  ventricle cavity volume and ejection fraction. The methods were tested on MRI images of a database made of 100 patients. The
  experimental evaluation demonstrates promising results and significant precision for deep learning algorithm on entire database
  while k-means might prone to failure if intensity changes significantly. The deep learning algorithm using TensorFlow backbone
  was trained several times with different training dataset and the results were compared.
* Data set is gotten from the [MICCAI challenge 2017 website](https://www.creatis.insa-lyon.fr/Challenge/acdc/)
* read through the pdf repot of project work for the description of the implementation and operation of the software.
# Medical-Imaging-Segmentation

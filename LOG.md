### 1/28/2025

- generated test cases for 2D system
- bug: particles for two dimensions don't fit since they are ordered randomly.
- sol: using a map to list them together and align them by sorting. 
- modified file structure: added tests file


### 1/27/2025

- completed systematic resampling implementation
- created test script for data and figures
- bug: if variance is zero, then sum of weights after update is 0; 

### 1/26/2025

- Completed 1-D particle filter implementation. 
- fixed bugs in Update and Resample function.
- generated test script that produces data and figures of the particles


### 1/25/2025

- implemented Residual Resampling function


### 1/24/2025

- fixed bugs. (see commit for details)
- moved estimate to dynamic. 

### 1/23/2025

- implemented Update function, assuming single landmark and gaussian measurement noise. 



### 1/22/2025

- implemented ParticlesSet class for 1-D system. 
- implemented constructor, estimate and predict function. 
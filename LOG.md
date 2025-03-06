### 3/6 
- implemented feedback control 
- generalized observation format
- used estimation value for update

### 2/15
- fix updating weights
- Completed 2D x_v system pf implementation

### 2/11
- I think the reason why the result diverges is that size of dt is too large, and the reason for collapse is sample impoverishment; 
- added gaussian init function
- separated jittering from resampling
- adjusted sinusoidal parameters


### 2/7/2025

- fix: different noise constant in predict for each dimension

### 2/6/2025

- implemented real system for straight-line

### 2/5/2024

- implemented good x-v system (straight line and sinusoidal)

Weekly Meeting: 

- System dynamics should align with the real data; Manually apply a noise in the true outputs, which is also populated by a dynamics with certain noise; Process the particles with another kind of noise, see if the original noise is eliminated; 
- make true system script that can be plotted and generate the observations from there. 

### 2/4/2024

- debugged Update function
- serious weight collapse; possible solution: lifebelt pf; 
- added particle jittering; 
- added linear test case, should try in non-linear cases; 
- increased the number of particles, simulation is making some sense. 
- bug: after many rounds of resampling, serious particle impoverishment; 

### 2/3/2025

- debugged functions and made test case in main.m
- waiting for further debugging

- implemented resample and estimate function.

### 2/2/2025

- implemented init, predict and update functions for x-v system

### 1/31/2025

- Current plan: (see folder Force_driven_sys)
  1. implement x-v system : time-sequential, multi-dimensional and mutually dependent. 
  2. after implementation, generalize it. 

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
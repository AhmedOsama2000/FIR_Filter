# Design of Lowpass FIR_Filter
### MATLAB & HDL Design

 - **Filter Specifications**
 - **MATLAB Design**
 - **HDL Design**
 - **Vivado Simulation**
---

1. *Filter Specifications*

    * Fpass             = 20 KHz
    * Fstop             = 28 KHz
    * Fcutf             = 24 KHz
    * Fsampling         = 160 KHz
    * Apass_attenuation = -0.1 db
    * Astop_attenuation = -50 db 
  ##

    > - Using hamming windowing mehthod
    > - To achieve this requirement the order should be **```66```** 
    > - Length = **```67```** 
#### Filter Specifications Scheme

![Specifications](https://github.com/AhmedOsama2000/FIR_Filter/blob/main/Filter_Specs.jpg?raw=true)

2. *MATLAB Design & Verification*
    
    * Desing the filter using **filterDesigner** Toolbox
    * Generate **MATLAB** script to obtain the filter Coefficients
    * Generate a noisy sine wave with **20KHz** for test purpose later
    * The samples & Coefficients are multiplied by factor **2<sup>15</sup>** to fit in **16-bit** input

#### Magnitude Response
![mag_res](https://github.com/AhmedOsama2000/FIR_Filter/blob/main/Magintude_response.png?raw=true)

3. HDL Design

    a. Top Level Module

    > sample_in width  = 16-bits\
    > sample_out_width = 32-bits *(because of Multplication Operations)*

    ![top_level](https://github.com/AhmedOsama2000/FIR_Filter/blob/main/FIR_TOP.png?raw=true)

    b. FIR Scheme

    ![filter_level](https://github.com/AhmedOsama2000/FIR_Filter/blob/main/FIR.png?raw=true)

4. Vivado Simulation

    * simulating with help of generates noisy sine wave samples from MATLAB

### Simulation Results

![filter_level](https://github.com/AhmedOsama2000/FIR_Filter/blob/main/Simulation_Test.jpg?raw=true)

The output is the original sine wave with **20 KHz** without the noise added before.

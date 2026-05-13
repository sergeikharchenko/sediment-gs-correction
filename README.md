# Particle Size Correction for Sediment Fingerprinting

This repository provides R scripts to calculate granulometric (particle size) correction factors for sediment fingerprinting studies. The correction is based on the Specific Surface Area (SSA) of the sediment samples.

> [!WARNING]
> ### 🛑 Important Geochemical Disclaimer
> **Do NOT blindly divide all tracer concentrations by the calculated correction factor ($W_{norm}$).**
> 
> Please consider the geochemical nature of your tracers:
> - **Lithogenic elements** (e.g., Si, Ti, Zr) are incorporated into the crystal lattice of minerals. Their concentrations are primarily driven by mineralogy, not by surface area. 
> - **Adsorbed elements** (e.g., heavy metals, fallout radionuclides) are bound to particle surfaces and highly depend on the Specific Surface Area (SSA).
> 
> However, even for surface-bound elements, correction via **simple division** is not always scientifically appropriate, as it assumes a strictly linear relationship passing through zero. It is highly recommended to explore **regression relationships** between element concentrations and SSA before applying corrections.
> 
> Ultimately, the calculated $W_{norm}$ factor is simply an attempt to describe a complex grain size distribution using a single numerical value. It is a simplification—use it thoughtfully and analyze your data critically!

## Features
- Converts cumulative grain size fractions into interval percentages.
- Calculates the total surface area (`Wsum`) of particles based on geometric or arithmetic mean diameters.
- Normalizes the surface area (`Wnorm`) relative to the source samples.
- Automatically applies the correction factor to geochemical dataset.

## Repository Structure
- `/R` - Contains the core functions (`gs_functions.R`).
- `/data` - Place your input Excel files here (**syntetic** examples included).
- `/output` - Corrected chemistry tables will be saved here.
- `main.R` - The main executable script.

## How to Use

1. Clone or download this repository.
2. Put your grain size data in `data/setun_gs_new_No.xlsx` (Sheet 1: Sources, Sheet 2: Targets).
3. Put your geochemistry data in `data/datatab.xlsx`.
4. Open `main.R`, adjust the `diameter_ranges` list to match your grain size fractions.
5. Run `main.R`. 
6. Find the corrected chemistry file in the `output/` folder.

## Mathematical Background
The calculation of the specific surface area is based on the assumption of spherical particles:
1. Mean diameter: $D_{mean} = \sqrt{D_{min} \cdot D_{max}}$
2. Particle volume: $V = \frac{\pi}{6} \cdot D_{mean}^3$
3. Number of particles: $N = \frac{\text{Volume Fraction}}{V}$
4. Particle surface area: $S = 4 \pi \cdot \left(\frac{D_{mean}}{2}\right)^2$
5. Total fraction surface area: $S_{total} = S \cdot N$

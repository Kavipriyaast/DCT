# README: 8-Point DCT Implementation with Traditional and Approximate Arithmetic

## Overview
This repository contains two implementations of an *8-point Discrete Cosine Transform (DCT)* pipeline:
1. **Traditional DCT Implementation:** *Uses conventional* *carry-lookahead adders and standard multipliers*.
2. **Approximate Arithmetic DCT Implementation:** *Incorporates* *approximate adders and approximate multipliers* to improve area, power, and speed efficiency while maintaining acceptable accuracy.

## Architecture
Both implementations share the same *DCT pipeline architecture*, which consists of:
- *Clock Gating*: Reduces power consumption.
- *Dynamic Scaling*: Adapts coefficients based on input magnitude.
- *LUT-based Coefficient Storage*: Provides predefined transformation coefficients.
- *FIR Filter*: Implements convolution-based filtering.
- *Adaptive LMS*: Dynamically adjusts coefficients for better performance.
- *D Flip-Flop (DFF)*: Stores intermediate results for pipeline operation.
- *Final Pipelined DA-DCT Module*: Integrates all submodules for complete DCT computation.

## Traditional vs. Approximate Arithmetic
### 1. Traditional Arithmetic (Conventional Approach)
- Uses *carry-lookahead adders (CLA)* for fast addition.
- Implements *standard multipliers*.
- Provides *high accuracy but higher power and area consumption*.

### 2. Approximate Arithmetic (Optimized for Speed & Power)
- Uses an *Approximate Floating-Point Carry Propagate Adder (AFPCPA)*:
  - *Precise addition* in the *most significant bits (MSB)*.
  - *Approximate addition* using *OR-AND logic* in the *least significant bits (LSB)*.
- Employs an *Approximate Wallace Tree Multiplier*:
  - *Faster multiplication* using *truncated partial products*.
  - Reduces *critical path delay* and *power consumption*.

## Expected Benefits of Approximate Arithmetic
| Feature                | Traditional Arithmetic | Approximate Arithmetic |
|------------------------|------------------------|------------------------|
| Speed                 | Moderate               | *Faster*             |
| Power Consumption     | High                   | *Lower*              |
| Area Utilization      | High                   | *Lower*              |
| Accuracy              | *High*                | Moderate (~98% accuracy) |
| Suitable for Real-Time | Limited                | *Yes* (Low-latency) |

## Conclusion
This project demonstrates how *approximate computing* can significantly improve performance and energy efficiency while maintaining reasonable accuracy in *DCT computation.* This makes it suitable for *low-power embedded applications* like *image compression (JPEG), video encoding, and DSP systems*.
